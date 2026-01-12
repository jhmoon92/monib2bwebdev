import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/features/admin_member/application/member_view_model.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../../../common_widgets/async_value_widget.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/delete_dialog.dart';
import '../../../common_widgets/fail_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../common_widgets/success_dialog.dart';
import '../../../common_widgets/warning_dialog.dart';
import '../../../config/style.dart';
import '../../home/presentation/base_screen.dart';
import '../domain/member_model.dart';
import 'invite_member_dialog.dart';
import 'edit_member_dialog.dart';

class AdminMembersScreen extends ConsumerStatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  ConsumerState<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends ConsumerState<AdminMembersScreen> {
  DateTime _lastUpdatedTime = DateTime.now();
  TextEditingController controller = TextEditingController();
  List<Member> memberList = [];
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return AsyncProviderWidget(
      provider: memberViewModelProvider,
      onTry: () async {
        ref.read(memberViewModelProvider.notifier).fetchData();
      },
      data: (data) {
        memberList = data as List<Member>;

        memberList = _searchQuery.isEmpty
            ? memberList
            : memberList.where((member) =>
            member.name.toLowerCase().contains(_searchQuery.toLowerCase())
        ).toList();

        memberList.sort((a, b) {
          int getPriority(int authority) {
            switch (authority) {
              case 1:
                return 1;
              case 20:
                return 2;
              case 50:
                return 3;
              default:
                return 4; // etc
            }
          }

          return getPriority(a.authority).compareTo(getPriority(b.authority));
        });

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 24), child: Column(children: [_buildHeader(), const SizedBox(height: 16)])),
              _buildResponsiveMemberGrid(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 버튼이 검색창 아래로 내려갈 기준 너비 설정
        const double breakpoint = 800.0;
        final bool isNarrow = constraints.maxWidth < breakpoint;

        // 버튼 그룹 위젯
        final buttonGroup = addButton('Invite Member', () {
          showInviteMemberDialog(context);
        });

        // 검색 필드 위젯
        final searchField = Row(
          children: [
            isNarrow
                ? Expanded(
                  // 화면이 넓을 때는 고정 너비, 좁을 때는 Expanded(남은 공간 모두 차지)
                  child: InputBox(
                    controller: controller,
                    placeHolder: "Search Member",
                    maxLength: 50,
                    icon: Padding(padding: EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                    onSaved: (val) {},
                    textStyle: bodyCommon(commonBlack),
                    textType: 'normal',
                    validator: (value) {
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val ?? "";
                      });
                    },
                  ),
                )
                : SizedBox(
                  width: 380,
                  child: InputBox(
                    controller: controller,
                    placeHolder: "Search Member",
                    maxLength: 50,
                    icon: Padding(padding: EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                    onSaved: (val) {},
                    textStyle: bodyCommon(commonBlack),
                    textType: 'normal',
                    validator: (value) {
                      return null;
                    },
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val ?? "";
                      });
                    },
                  ),
                ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                setState(() {
                  _searchQuery = controller.text.trim();
                });
              },
              child: Container(
                height: 40,
                width: 116,
                decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                alignment: Alignment.center,
                child: Text('Search', style: bodyTitle(commonWhite)),
              ),
            ),
          ],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topTitle('Admin Members', 'Manage system administrators and roles', _lastUpdatedTime, () {
              setState(() {
                _lastUpdatedTime = DateTime.now();
              });
            }),
            if (!isNarrow) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [searchField, const Spacer(), buttonGroup]),
            if (isNarrow)
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [searchField, const SizedBox(height: 16), buttonGroup]),
          ],
        );
      },
    );
  }

  Widget _buildResponsiveMemberGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          const double minCardWidth = 300;
          const double spacing = 24.0;

          int crossAxisCount = ((screenWidth + spacing) / (minCardWidth + spacing)).floor();
          int actualCrossAxisCount = crossAxisCount.clamp(1, 4);
          final double itemWidth = (screenWidth - (actualCrossAxisCount - 1) * spacing) / actualCrossAxisCount;
          return Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children:
                memberList.map((data) {
                  return SizedBox(width: itemWidth, child: MemberCard(data: data));
                }).toList(),
          );
        },
      ),
    );
  }
}

class MemberCard extends ConsumerStatefulWidget {
  final Member data;

  const MemberCard({required this.data, super.key});

  @override
  ConsumerState<MemberCard> createState() => _MemberCardState();
}

class _MemberCardState extends ConsumerState<MemberCard> {
  bool _isOverlayVisible = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: commonWhite,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: commonGrey2, width: 2),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                widget.data.authority == 1
                                    ? commonGrey7
                                    : widget.data.authority == 20 || widget.data.authority == 50
                                    ? newBlueBg1
                                    : commonGrey1,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.data.authority == 1
                                ? 'MASTER'
                                : widget.data.authority == 20 || widget.data.authority == 50
                                ? 'SUBMASTER (MANAGER)'
                                : 'RESIDENT',
                            style: captionTitle(
                              widget.data.authority == 1
                                  ? commonWhite
                                  : widget.data.authority == 20 || widget.data.authority == 50
                                  ? newBlue
                                  : commonGrey5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isOverlayVisible = !_isOverlayVisible;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: commonWhite),
                            child: const Icon(Icons.more_vert, size: 24, color: commonGrey7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor:
                              widget.data.authority == 1
                                  ? themeYellow
                                  : widget.data.authority == 20 || widget.data.authority == 50
                                  ? newBlue
                                  : commonGrey5,
                          radius: 32,
                          child: Text(widget.data.name[0], style: headLineLarge(commonWhite)),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.data.name, style: headLineSmall(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.data.status == 0 ? successGreen : commonGrey5,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.data.status == 0
                                      ? 'Active'
                                      : widget.data.status == 1
                                      ? 'Pending'
                                      : 'Lock',
                                  style: captionPoint(commonGrey7),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/ic_24_mail.svg', colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.data.email,
                                  style: bodyCommon(commonGrey6),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              SvgPicture.asset('assets/images/ic_24_call.svg', colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.data.phoneNumber ?? '-',
                                  style: bodyCommon(commonGrey6),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('ASSIGNED TO', style: captionTitle(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_24_location.svg",
                          width: 24,
                          colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        widget.data.assignedBuildings.isNotEmpty
                            ? Expanded(
                              child: Wrap(
                                spacing: 8.0, // 좌우 간격
                                runSpacing: 8.0, // 상하 간격 (줄바꿈 발생 시)
                                children:
                                    widget.data.assignedBuildings
                                        .map(
                                          (item) => Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(color: commonGrey1, borderRadius: BorderRadius.circular(16)),
                                            child: Text(item, style: captionTitle(commonGrey5)),
                                          ),
                                        )
                                        .toList(),
                              ),
                            )
                            : Text('-', style: bodyCommon(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('Last Access', style: captionTitle(commonGrey6), overflow: TextOverflow.ellipsis, maxLines: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/ic_24_time.svg",
                          width: 24,
                          colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.data.lastLoginDate != ''
                              ? DateFormat(
                                'yyyy-MM-dd HH:mm',
                              ).format(widget.data.lastLoginDate != null ? DateTime.parse(widget.data.lastLoginDate!) : DateTime.now())
                              : '-',
                          style: bodyCommon(commonGrey6),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
        _isOverlayVisible
            ? Positioned(
              top: 60,
              right: 24,
              child: Container(
                height: widget.data.status == 1 ? 100 : 140,
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: commonWhite,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 2))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isOverlayVisible = false;
                          });
                          showEditMemberDialog(context, widget.data);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/ic_16_edit.svg", colorFilter: ColorFilter.mode(commonGrey6, BlendMode.srcIn)),
                            const SizedBox(width: 4),
                            Text('Edit', style: bodyCommon(commonGrey6)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _isOverlayVisible = false;
                          });
                          showDeleteDialog(
                            context,
                            onDelete: () async {
                              try {
                                await ref.read(memberViewModelProvider.notifier).deleteMember(widget.data.id.toString());
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                  showSuccessDialog(context, 'The ${widget.data.name} is deleted.');
                                }
                              } on Exception catch (e) {
                                showFailDialog(
                                  context,
                                  'Failed to add unit',
                                  'Something went wrong while deleting the member. Please try again.',
                                  () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            },
                            name: widget.data.name,
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset("assets/images/ic_16_delete.svg", colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                            const SizedBox(width: 4),
                            Text('Delete ', style: bodyCommon(Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    widget.data.status == 2
                        ? Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isOverlayVisible = false;
                                showWarningDialog(context, () async {
                                  Member updatedMember = widget.data.copyWith(status: 0);
                                  await ref.read(memberViewModelProvider.notifier).updateMember(updatedMember);
                                  await ref.read(memberViewModelProvider.notifier).fetchData();
                                }, "Are your sure to unlock this member?");
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.lock_open_outlined, size: 16, color: successGreen),
                                const SizedBox(width: 4),
                                Text('Unlock', style: bodyCommon(successGreen)),
                              ],
                            ),
                          ),
                        )
                        : widget.data.status == 0
                        ? Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isOverlayVisible = false;
                                showWarningDialog(context, () async {
                                  Member updatedMember = widget.data.copyWith(status: 2);
                                  await ref.read(memberViewModelProvider.notifier).updateMember(updatedMember);
                                  await ref.read(memberViewModelProvider.notifier).fetchData();
                                }, "Are your sure to lock this member?");
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.lock_outline, size: 16, color: themeYellow),
                                const SizedBox(width: 4),
                                Text('Lock', style: bodyCommon(themeYellow)),
                              ],
                            ),
                          ),
                        )
                        : Container(),
                  ],
                ),
              ),
            )
            : Container(),
      ],
    );
  }
}
