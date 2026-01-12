'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {".git/COMMIT_EDITMSG": "8439beb8b1732c0a2985d22d90c57484",
".git/config": "920a11de313bfb8d93d81f4a3a5b71b6",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "ecbb0cb5ffb7d773cd5b2407b210cc3b",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "e4db8c12ee125a8a085907b757359ef0",
".git/hooks/pre-push.sample": "3c5989301dd4b949dfa1f43738a22819",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/update.sample": "517f14b9239689dff8bda3022ebd9004",
".git/index": "29c1fb3925716f0039599df95855dc49",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "f065cf6e207a7ceedb270c37fab581c3",
".git/logs/refs/heads/master": "f065cf6e207a7ceedb270c37fab581c3",
".git/objects/02/1d4f3579879a4ac147edbbd8ac2d91e2bc7323": "9e9721befbee4797263ad5370cd904ff",
".git/objects/03/f69ba84978125a17afc19020653d46073ec048": "d48f1bd3436812e574628389bcfb2e63",
".git/objects/07/678093fa4260120ea0e6986636f72d5120b9eb": "c75649017f1a4f56717445f81608223d",
".git/objects/13/8520d995d1a34af6e3c04ca953d798afdbcc7f": "ed5a50de7e984043d9e4f23d470e90cf",
".git/objects/13/eecb7823751baf5a75ccf74f3aa79374feac9f": "b55f95aa10d8cbe4df7d9227638e142b",
".git/objects/14/c23a8263c5cbf7527d114e3e5d8b625647dce1": "ec154be1c4553398858e260c181d00f7",
".git/objects/15/211d98a9dc830f5ca17ba9a5e4608734004527": "8ad94a600db61e84e374b7aad68cb744",
".git/objects/15/6ce96ad8eba4c97c81e5c8d09afe0d96098895": "2b9e1e172637adf89261433916dfa324",
".git/objects/1c/3ceb216796ca4d8804e5149de6bc7910cb6a76": "6fcb8d9d8a7bed955d3d1e25f13a4d7d",
".git/objects/1d/5039f6b3d414d07c5d3770109c1aa5a9b11c57": "cff87f084e61a538c6ae3ea630f37c3d",
".git/objects/1d/7eaafa8de200f35ef085ca9d3845bac981bb79": "fef42ca68ae2122ce7167ce2d8f8f04e",
".git/objects/1d/cb5a34d44ef66a10c871c2622031bda8a7c3c2": "d84c7868d2a112d7e4eebb32a41afeb2",
".git/objects/20/2e6db2e096f7d9d2f8deb64550a86a7f37598c": "696a08a6df6f1e6a8249ee1170ccae38",
".git/objects/20/3a3ff5cc524ede7e585dff54454bd63a1b0f36": "4b23a88a964550066839c18c1b5c461e",
".git/objects/23/f3d146ec6fe3ed8f64fef073563a84512fd5a7": "d2698b3253962037e9776fa1fd48414b",
".git/objects/24/4752ba6fff604812d1cd372ad7d50648540776": "d17b397054440fd92df08ae5d6d905bd",
".git/objects/25/84720c17db6e91e6ba159847ba371eaf426644": "6828254695b92600f5f1cca599f63c0b",
".git/objects/26/0e87670ce24754ea29627033265c5a322345e1": "2d8c6dec78fb63dbd0f5635110ed54ee",
".git/objects/29/f22f56f0c9903bf90b2a78ef505b36d89a9725": "e85914d97d264694217ae7558d414e81",
".git/objects/2c/a66a7c5c2e717ec13854684391a3c5aaaf1f1b": "bee4600f8275b44687ae4792bfe81b8c",
".git/objects/2d/313bd17cc479258f9ddae47d3f7629a35fe8df": "d2360ce33afd5569ed9dfb1d03be8cca",
".git/objects/2d/9b629b54a83e7635d6e75ff10fb3e05022cb6b": "6288661351e12cd3850919d9291b3dc8",
".git/objects/2e/5599bdaf9814b90a211d1006795e7582571cc1": "99d67e99b7ae3f3f8dcd9c4ca02d3f38",
".git/objects/30/b5895c2cca1a170506e973cb881c0168424472": "add536a03b8b9ac8621df2a82e6a7222",
".git/objects/33/81bc01f468fb4fce9ecead2e6346e255e2aef6": "a1cf12a032339cf795076157b7902ec2",
".git/objects/35/184e25e3dd5e94bb0a05fdcd7df0fe3efacb14": "f8ac967d39d69c7e0ab4dd9aedc18d78",
".git/objects/35/7319e5d259eba1013f5d699b9428c8f282694b": "a3209affd66a0480c7782d155eeff39d",
".git/objects/38/e4bdb3731b761e1c28fd82e0f7862807c11d6e": "c6e085340a1979843f534c9cdddbcb3f",
".git/objects/39/7478819bf59204897445e9d9501a4e5776c127": "4a8eca5f5c9c31b10dc0b21801a3763a",
".git/objects/3b/10e507c6e7128de501392b3d28bb30095a0adf": "35c60fb9e21e05bdacb80af0fa8644cd",
".git/objects/3b/a4d74306fb8e11ab08673d04eb01c99cf82511": "0b10987a7e6fd729446dc2a87ea434a0",
".git/objects/3d/9bc6bbf511157d36029e526a512a96dcc6d3fc": "abd086476d46c8b3d107b06bde395473",
".git/objects/41/7851764e5fdbcf71fb515c4e6955ec44d6725c": "dc17246fd6719b698687ef31884d6551",
".git/objects/44/44d426d331716371541e92f49170ada4a7edb9": "2e390b27549aea5b19a36073575a2dad",
".git/objects/44/4cbc9cf919fac5c9308746809a19e32127ecdc": "8dc7b373802d4255cd3be9ef1017dc01",
".git/objects/44/e6df2ed19eff188fc5d6240a8e3dbb03c068e7": "3d352e9bbcd969a107208315dbe5b255",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/46/8bdba3ed8eb61ce0c318547fa9c7a81a810eb4": "c4ab4e3d718fbb292edba0fa084ca4be",
".git/objects/46/d9633f8e45a809605359ca2f4c6b8f0a2ca267": "df757b3d7fad27ee564c9ab7d2c13529",
".git/objects/47/00344d04ac2460971cb7ecb3068a1086833464": "edc5499396b4de86f0e7254edabaa462",
".git/objects/48/6e051a2bef6f6a362f28de8c717ec6bb4a711d": "a420b89bd51598dde3c04ad3316499f7",
".git/objects/49/07e257b9199aca569cf7423ae3b7bfac3a7463": "6cdf08a92a3414045de82243164a8d31",
".git/objects/4d/bf9da7bcce5387354fe394985b98ebae39df43": "534c022f4a0845274cbd61ff6c9c9c33",
".git/objects/4e/0c4f464b4f9b2316c6e14bfcac2b785bc8d9a2": "cbb582d896905442edd70cf8cc242ac3",
".git/objects/4e/6511e7171c0c5afb7c39fe3e6b66e1640b3ee3": "ae76ffe4f7e775cf26c3a3f064e21a59",
".git/objects/4e/7988cf579d951b41539344cb17d8074bc02064": "9a073a1cf6b21ff1ea778a4019833811",
".git/objects/4f/fbe6ec4693664cb4ff395edf3d949bd4607391": "2beb9ca6c799e0ff64e0ad79f9e55e69",
".git/objects/54/a51e926ac284fc28f1582db61365ff921ac721": "aee6851af8b20e2055671fa571ac086f",
".git/objects/57/c7b25e23398a76a4f1c8c0eac10a305b8cf75e": "949bf6959855bfeeedd4cb1a3eeac5e7",
".git/objects/5b/218f40552a87aba390389dfe55564929a09286": "42e77cb9be0bae4cb2be6038ab474614",
".git/objects/5c/25c9cd7a08596d319c112c5869b7b227e6d485": "d6841f046064d811e0faa83c4f050831",
".git/objects/5c/6bd248f458adef472739974de7a18fc92826f1": "2bb1611ce1109afcfc10d4ac13933b44",
".git/objects/5c/9d369c92a41d671dd2dd6c9fad861a75546845": "0ddd998bf67adafc25eb47db96cf7e05",
".git/objects/63/1ffb62750ca306ab4d8320fc1d58f271b7cbed": "af22546f9b90613b381d3f54499601d3",
".git/objects/66/3680093d2ba1165ac01ec9465b3b394268ebca": "fb90d3f3b6abd391d48ffc29bd15461d",
".git/objects/6b/9862a1351012dc0f337c9ee5067ed3dbfbb439": "85896cd5fba127825eb58df13dfac82b",
".git/objects/6d/8cfb3129b591a8f446554a82a35f784968df6b": "c94842dae67504d677765f16d791ba8d",
".git/objects/6e/483ac5dfd185903c0832136fa6f89940033307": "3cc91a9333833731973fd87bb5fcce93",
".git/objects/72/5fce7339e2dba64d503c24a8fe1783e6b1737a": "615a9977d9d84b956ffeb79bd25ee6bd",
".git/objects/73/20def0d7a59e465c6c9f4aa0da2f7f4b526d52": "fdfe815731a4c1861144d3c7417d5398",
".git/objects/74/34f024c6910e1175c0cffe451ecc88b268824b": "c74626a706ffaefd0a17f41b0e3dd965",
".git/objects/75/3939691cba56abfe98c4d2826d49e474de4432": "e01ce0514806302142ff6994bfd48e9a",
".git/objects/76/2b741d34f1f379bce7edf2cfd1f1c7592da569": "1077ba3803def9435478e24bbbfb9276",
".git/objects/78/876e1831795f5385ac3cf31253537163f7af07": "4144c3f9d493200b49822e87453f5fc0",
".git/objects/78/c79c20bdff1afb918b8375fbbeacfe77074537": "fc4068e05e28f2a8c62b2bab3576c37a",
".git/objects/79/0e720ae6234bfdce34fe2e71b48149153ba140": "39648cfae5ac1f9fc192c1899c2520eb",
".git/objects/7a/4cad16a9729b2e5e63df6235b31e8e74ca5e26": "fcb61e3611ec7348fe29f2737c8af6e2",
".git/objects/7a/6c1911dddaea52e2dbffc15e45e428ec9a9915": "f1dee6885dc6f71f357a8e825bda0286",
".git/objects/7a/d90de856bdc7c8bfbe38856c69a5abe317aab2": "8ade01a247301d551dd48feecc9a72ab",
".git/objects/7b/df68d83e74b0802331dc0f6f63577492e5d1a0": "2f8ffeb15e4e2a401191eb5ba625fc1d",
".git/objects/7e/342d14433f02e1f14b06cbd56687df33f875a1": "e54dad003449ae237ad33bdb141fd9a7",
".git/objects/7e/5014ea48eebabbbff0726d539f4eaa75377d2b": "6b88fce244cfb238505e070853f502ba",
".git/objects/7e/901badde3ef5d0be3601adbdd52df8379f73b9": "a14e11ef07e674dafbf0559cdf9b4ee3",
".git/objects/83/2cf0cbe1d2b63e73752e36515eabfb59e1b9d6": "db73a6c23c7850eae8194f420ba7c7cb",
".git/objects/85/54c373fb4229ecca37524405798719dc29bb93": "ce334c59e827816078b2466e5277ceb9",
".git/objects/85/7220909fc820f3d87f787361557d68c7f3ded9": "5e4f4b8e8f92a7c2858d19d7bebeacfc",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/88/f6b581ed1aea89840011510f10bb0cbe5923f7": "1ff1cfb561940b51e7276d3abf22fe2d",
".git/objects/89/111a49614d1ef77bf6bfa471ffbcbcc3eb14ae": "29b8b2923e407e4aa0a9fc9e676467fe",
".git/objects/89/6a4877c9dde19e49ba25fe3e74a52d856baf44": "b64b9eb5ea455abcefdf5272d089c8ac",
".git/objects/8a/7598aaf5be931c376b792475d91213a0dd8193": "fe63fdf0aea8c30513ed5e01b4fa1d48",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8c/3fdb0e6dbfcd41399904ef1d6d4ad4059ef23a": "deb033e4c1566b40a6a392adefc56aed",
".git/objects/8f/84fe069bd8b2e60abded4febd99ab360c705fe": "de5cc4cc6504a91a0234f7ebc01f6558",
".git/objects/8f/e37393800dabe700c8865bc5f4d66927a030ba": "1909d7e57cc8319c29c583592319fdb8",
".git/objects/91/67bfa1f0280bd30c1501e960b77209a57d8033": "a98b5c7b3cab52290dee8e2fcda0d6d2",
".git/objects/96/8d5039e8230e5b490c63d8f9f70d6164d61d99": "a6eea58aab9c77fa9916ed914bdc14f2",
".git/objects/98/0d49437042d93ffa850a60d02cef584a35a85c": "8e18e4c1b6c83800103ff097cc222444",
".git/objects/9b/06f0726afc8f62360572f3f8713be0011a836e": "f4a3661d7b18de92fc3d4d20faa64ea7",
".git/objects/9b/3ef5f169177a64f91eafe11e52b58c60db3df2": "91d370e4f73d42e0a622f3e44af9e7b1",
".git/objects/9c/572d1aaee65508077ff81319532e5ce25a4de0": "f048a52b4ca66b7ef5f6ac5170343e2c",
".git/objects/9d/f62232ba2a59284c52b395af77f7d5ac4282a0": "a9a42571754721b1421438f3e8846ccd",
".git/objects/9e/3b4630b3b8461ff43c272714e00bb47942263e": "accf36d08c0545fa02199021e5902d52",
".git/objects/a0/d05fc2377f4669569fcdc32a356610a6236825": "b0ec1c890eeb575a8a78c1045d921d60",
".git/objects/a3/6b4d99c2bf63849c85d7d49102d834b56a2d91": "b45b35def7aeadeb6dfc666b5949af21",
".git/objects/a3/8a87d5334a58f5c482a42d0e283be8df3fffa7": "b07fc4110c63545d133aa1afd0c6584e",
".git/objects/a9/370dc76ea6645792d5ca656ada7e3293ac44c7": "773b869bf72aa4f25e8cc3916710b355",
".git/objects/a9/b7f1ad7845e7de5404c6b198ca750cc2bfb2df": "ca5271de383adffbc9ddb6894e3a5198",
".git/objects/ab/16d8ad1b16c141c44ca13878e3c4370ed3ddcf": "7eb9e59b742721880f6421d09d8e802d",
".git/objects/ab/6604faeb6d47dc54cd1023c263a07339b85ee7": "d361a030ae99379b17604e93c2b5ce49",
".git/objects/ad/0491286512b8a1d8f3a0ee2493b4fd6cdd3e46": "799cb23c0a6a17cf7c2c8e6abde15fdc",
".git/objects/ae/752d48d9c5c46b76f3568a4f8e1f52f1f1b67f": "f318195e7451dfaf1f90406c4d9f799f",
".git/objects/b3/e7f08a0105d00039d75249dcebc12f7f71daaa": "70ff4e6c7d287dd90738989729eb14f8",
".git/objects/b5/84207eb77be29705ceae589850da569dcfbfeb": "2462229cb1241faa27a5c456114a4757",
".git/objects/b5/e1fecb4266344e640026bf18bd7d028f30d02a": "6dd2cf0039a16158497bf225fed5278d",
".git/objects/b6/b8806f5f9d33389d53c2868e6ea1aca7445229": "b14016efdbcda10804235f3a45562bbf",
".git/objects/b7/104e7868adb8f93f5c8be6e7e0ba1fc9e434ba": "9ba63a67271207fea99c86ced52df36e",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/b9/7526e6a19887af714c023c93506102e17716d4": "3d98c7c706c9c2e6d69e4e61c65ea9db",
".git/objects/ba/53621c1485c43382994cd4eaac70ed8006ac14": "428c84f3fd29d2b832289ba3c72a2619",
".git/objects/ba/7cb107cb0049ff36ce2c75a1c320c2567fcfe0": "41a312bb4de4922592fdd0bb8eb0a652",
".git/objects/ba/a7c1f66ec227be6718041a9d0ebddccbea45e9": "1006de14cf27ac183755c222c24f745f",
".git/objects/bd/08625bf5b0d70b1a1e31a1d498270fef4df433": "1743bd1e72c6e65393367564033e2994",
".git/objects/c4/016f7d68c0d70816a0c784867168ffa8f419e1": "fdf8b8a8484741e7a3a558ed9d22f21d",
".git/objects/c5/ab5b79c8c3a8631251e25b0ca671959583a970": "7b78976392a6df342cd694aaaa56912d",
".git/objects/c6/d4e73447f803518944421f32987e344cac1bf9": "97e15a6708e6fe17d4c46e53af371185",
".git/objects/c7/bf3d40d993ed0aca7777e79201192964993382": "3679d3eaece4ed04ce01cb2a3e026bd4",
".git/objects/c7/eddb86109b03bef26a665e5096a4f8ba1dd161": "4f9d157a3303e5ae3cd30bedc13368e7",
".git/objects/c9/d9f110f6e9d08e905881ba471ecaef443fb9ed": "cb7f64a941ec7446dd669f9ba4e3a43b",
".git/objects/ca/3bba02c77c467ef18cffe2d4c857e003ad6d5d": "316e3d817e75cf7b1fd9b0226c088a43",
".git/objects/cb/f8a5f9858975547a6191c130f1971c7574b4ea": "c29e755e34ba62a7e6816f312856cf17",
".git/objects/ce/127e58ccf55135ade81bb08c6f4134ecb31483": "3c0d94010625d9b4577e51d440886803",
".git/objects/d1/8f6e3f3468fde309e33b886c65e46b3f337e7e": "83e55ff047388db37981c6f0e02e5237",
".git/objects/d3/edce0871b2fa7d8dcddc057c1117b92f6a781f": "3f556e576092e61dab19de3b76031a5e",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/9e71d9624aea66540a92025dc4f7bc9d9f473d": "be34cf0eaafe3519e4de9ad32d670c51",
".git/objects/d6/7d886ba6664c276cff620b86bca7665148dca2": "0f1d63e96a4c1122ebf79a087c998985",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d7/7cfefdbe249b8bf90ce8244ed8fc1732fe8f73": "9c0876641083076714600718b0dab097",
".git/objects/da/0080301c1e9e476bd55cd89878cd9f3a9f7b0a": "596d31f3d0a9a0d6d44ee4be6a87119a",
".git/objects/db/32b17d3d78eb28bc8bf9955e7e7cdb374f8649": "80059f7c7ae447870732b8d0d8b6ff43",
".git/objects/de/27662c25829cd003e24189a9f775e91911a592": "9aa05af8e0a74a6f8830afa6b627e01f",
".git/objects/df/257e0f935700c1bb4582dbaca4420a8129e0ea": "1a2a5486bbddf7797b3b3ef3d697a506",
".git/objects/e0/b14bcff6d294624774ca07fc74b21706983817": "75f2315270a32e3911d6026eefd58218",
".git/objects/e3/e9ee754c75ae07cc3d19f9b8c1e656cc4946a1": "14066365125dcce5aec8eb1454f0d127",
".git/objects/e7/7d4714c1cbe7ef65fdcf156517d10674b5c211": "416bab1d96ae19c7034b40f30429a082",
".git/objects/e9/94225c71c957162e2dcc06abe8295e482f93a2": "2eed33506ed70a5848a0b06f5b754f2c",
".git/objects/ea/197bf1ec8ba67c6a41d2d0deec17b593abb3c8": "b86b9febd922a74eb150a366cdd06092",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/eb/d2a880e46805a147f305524bd93dc3941e5dfd": "d5ceeeef0cde5432d0a1193959bfbfb4",
".git/objects/ed/b55d4deb8363b6afa65df71d1f9fd8c7787f22": "886ebb77561ff26a755e09883903891d",
".git/objects/ed/f13cfe4b7956027f930ae145e481ce710fd4c1": "1dcdc94fdaf4e12bdde6ba0de71e67ea",
".git/objects/ee/1877d8f8c8bc9d27fcbbe2ec7874edeb28a152": "61bbe35dd7583142cb78c35b1734ea5a",
".git/objects/f0/27d58ecc281b7de82522c4170bdf35709b4278": "f8803f01afdd731f43147e2c2751314b",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f3/040dadf8eeb1b242d0fede77092528344df72d": "d27960a6e291ae76e075c6d1a4431cdc",
".git/objects/f3/2f8396eb3ccd806073a16514b968995fc715c8": "4b447c4ddce864d958e13cdfd2fa991c",
".git/objects/f4/0d26cf11f2769ba073b35ab08fa4053a24b63f": "452bebd873b55fa4b7e44a43b1dc6d06",
".git/objects/f5/72b90ef57ee79b82dd846c6871359a7cb10404": "e68f5265f0bb82d792ff536dcb99d803",
".git/objects/f7/29a4014a9d973472adb3dbe6ae8be91cd1f46f": "bb8d5ad0a489c6899ede4ca1547686dc",
".git/objects/fb/3e0a32faae453708915b0ec96d22e1fbd1d88d": "00533265f40cc4320cee424691576e23",
".git/objects/fe/3b987e61ed346808d9aa023ce3073530ad7426": "dc7db10bf25046b27091222383ede515",
".git/objects/ff/0005c1cbe665c593e408d7bacad13b6c25f1fe": "faaf9add17ea5f79e93acd503dae5684",
".git/objects/ff/fd492995603d0bd3aa73e8e56aec13fb58d144": "4cf06b783aa3a0b901a809971169b3c9",
".git/refs/heads/master": "e09f1c91715ce42bf4ed066f9755f73d",
"assets/AssetManifest.bin": "06bc947f041aae7c471aca49c6136936",
"assets/AssetManifest.bin.json": "c0da43e1bd4ae40981aa975017d11d46",
"assets/AssetManifest.json": "ef029569d30e8e49c82f1a6c76522eb7",
"assets/assets/development.config.json": "490308f74cb99650f69fab0a8fcc5401",
"assets/assets/images/ic_16_attach.svg": "d7dd510621127b131ba59669e796bbf2",
"assets/assets/images/ic_16_delete.svg": "4953e35dc6d430d76dc698adb19700b8",
"assets/assets/images/ic_16_download.svg": "376a59a5d7dffe3f2d20fca86174a498",
"assets/assets/images/ic_16_edit.svg": "65650cf7e2f39dbd2874bc436b4af09b",
"assets/assets/images/ic_16_search.svg": "74d70b916ec91e300e3104a21041c933",
"assets/assets/images/ic_24_3dots.svg": "48ae3aa1ef3709f5a71e22dc99e9efc0",
"assets/assets/images/ic_24_add.svg": "d3aff679a4fdfed322eddcf30a454e7c",
"assets/assets/images/ic_24_alert.svg": "61a0fdbb968e1d2410fe0cefaf2ef37d",
"assets/assets/images/ic_24_call.svg": "3d082ef87e484aedece08dbc843a8731",
"assets/assets/images/ic_24_cancel.svg": "fa29039c00e5742886162192f832d128",
"assets/assets/images/ic_24_check.svg": "06beece71761d876df250a6619cf8283",
"assets/assets/images/ic_24_download.svg": "b6a63da4a78ce689fe75ace026cfc65e",
"assets/assets/images/ic_24_edit.svg": "47975e2a044b01dbf3f10fe4541cb7bf",
"assets/assets/images/ic_24_home.svg": "27d058651b7b0704e9af640d8c02b4a1",
"assets/assets/images/ic_24_important.svg": "3e9fe16beabe02da9ad36195dc3c11e6",
"assets/assets/images/ic_24_info.svg": "7acb2a1437d49e6c367386e4c0b3d432",
"assets/assets/images/ic_24_location.svg": "7b5b1d68698e23a4b651d83e29e0f9c8",
"assets/assets/images/ic_24_log.svg": "c8068480615c41df4de85f01e1b23fcd",
"assets/assets/images/ic_24_logout.svg": "d34052cec5976c7bd1fed0859aeacdd0",
"assets/assets/images/ic_24_mail.svg": "d3293957274492e9d0117d4670db7e0d",
"assets/assets/images/ic_24_motion.svg": "d61d0d07cd0faf7ff8296eddf4b366d1",
"assets/assets/images/ic_24_office.svg": "d43d88ec741d507bb772753acfef0e45",
"assets/assets/images/ic_24_people.svg": "a954932875080809e1b2a757f20996bd",
"assets/assets/images/ic_24_person.svg": "6b46fc9817c10d9a58e86e59ba2d39f3",
"assets/assets/images/ic_24_pod.svg": "1461940f931b10f90e36e5849f7f2793",
"assets/assets/images/ic_24_previous.svg": "9cf768ea140cf8ffddd42216d68512da",
"assets/assets/images/ic_24_radio_off.svg": "f8ddb25d49390b543e9aa03f5a28333a",
"assets/assets/images/ic_24_radio_on.svg": "9e7c9a969d814084719d3dd7447530c6",
"assets/assets/images/ic_24_reload.svg": "2b7017d4f0748d2b15c0f0ddbf20f8dd",
"assets/assets/images/ic_24_room_1.svg": "e0debc6a2ecff6ca0b4956c22bac5807",
"assets/assets/images/ic_24_success_circle.svg": "b79a56d111d9a0335d4a507b9fae32aa",
"assets/assets/images/ic_24_time.svg": "5737c4146bddbf043ef5fbcb7803fceb",
"assets/assets/images/ic_24_unit.svg": "0c43136fd4d597121368162971a2f51c",
"assets/assets/images/ic_24_upload.svg": "4ddac8000bd667eb7f2a33b2f4821e3b",
"assets/assets/images/ic_32_call.svg": "231be24f0085be62ea9061fd09a97fd1",
"assets/assets/images/ic_32_circle_cancel.svg": "1bb5792484840aa036f66d18564d492d",
"assets/assets/images/ic_32_circle_check_checked.svg": "eb0d82c10c19170b263b34217a5be81f",
"assets/assets/images/ic_32_critical.svg": "3bdd4c7907c641579d9ed49daca12db2",
"assets/assets/images/ic_32_eye.svg": "bf725673f11baa173798315a7205e0c6",
"assets/assets/images/ic_32_eye_off.svg": "fe648908639242009c3a68660f19f499",
"assets/assets/images/ic_32_warning.svg": "9f86e6e10efbdfe7926ee27b14a98554",
"assets/assets/images/ic_48_wi-fi.svg": "48b8f73841a2949059f9b85d249cadb4",
"assets/assets/images/ic_48_wi-fi_error.svg": "9ce20eea1ddd1e074bdf0e13224a8f80",
"assets/assets/images/img_80_building.svg": "8afd741c302ee6af6edbf6e462a37d0e",
"assets/assets/images/img_bg_building.jpg": "3569bbd39b8d1a6f76cd25aadf0b2150",
"assets/assets/images/img_bg_building2.JPG": "89aca5e75acc39787f4411899e838733",
"assets/assets/images/img_default_building.png": "8b7f5091722d461f64a830162c06d89e",
"assets/assets/images/img_logo_moni_resipass.svg": "4780b04ec2a61aec4e7cfa72748d92c3",
"assets/assets/images/img_logo_s_moni_resipass.svg": "7349cc0f3d0340f26335224c59f1e064",
"assets/assets/images/moni_logo.png": "3a434bab51bf4ac8b625f7c0c1aa192b",
"assets/assets/images/Moni_logo_signiture.svg": "694192f30ec4ff316e5608ab756a8d58",
"assets/assets/images/Moni_top_logo_signiture.svg": "4b5497a497322f8b39c956f19ebfbbe4",
"assets/assets/lotti/add_place_not_found.json": "93c7d3d934f4c80e58a46e17d7eac83d",
"assets/assets/lotti/connecting_monipod.json": "b92ea2ba4ab4ddf36864a9b4a4ecbe2d",
"assets/assets/lotti/find_moni_pod.json": "f0db87ddd120b2e39559d0970b277d86",
"assets/assets/lotti/graphical_loading.json": "30ba27b0f99ffe8e773f1b46fc145769",
"assets/assets/lotti/loading.json": "1e576825017148e2b47e06d7634dbb5a",
"assets/assets/lotti/loading_dots.json": "5b4e248161d9f1903fefab69ebaf7d97",
"assets/assets/lotti/Moni_2.5_Home_Day.json": "b3d8e39df615bc75b11be9619595369d",
"assets/assets/lotti/Moni_2.5_Home_Night.json": "bf9eed46a50b48f96e6711854a3d72a4",
"assets/assets/lotti/moni_link_icon.json": "5c6f0c5c399667ef89e5d667761f214e",
"assets/assets/lotti/moni_place_introduce_illust_1.json": "5c6f0c5c399667ef89e5d667761f214e",
"assets/assets/lotti/moni_place_introduce_illust_2.json": "4353080af7817100c02c157517a159fa",
"assets/assets/lotti/moni_place_introduce_illust_3.json": "795c130ba025948fd091654febb9c934",
"assets/assets/lotti/Moni_Pod_Color_LED_Blue.json": "ed6ac225a7193be90505e2ca52a26bdf",
"assets/assets/lotti/Moni_Pod_Color_LED_RED.json": "ac458ef02dc1b6a22e99f76514ae62a7",
"assets/assets/lotti/Moni_Pod_LED_Blue_MAX.json": "7286b7833caf3a8d4fed6897cff55df3",
"assets/assets/lotti/Moni_Pod_LED_Red_MAX.json": "409b27cce03e7426df0f6b74b51b29f1",
"assets/assets/lotti/Moni_Pod_LED_White_High.json": "d2bc4a1d103cdf437c99fc8d91439aad",
"assets/assets/lotti/Moni_Pod_LED_White_Low.json": "ae30e2a7b57a92626d90771b4b44187a",
"assets/assets/lotti/Moni_Pod_LED_White_Mid.json": "e1a7ce9706efd4992291238eadb116e5",
"assets/assets/lotti/Moni_Pod_Network_Scanning.json": "27cba0ad1ca197173a6886bb94896b2b",
"assets/assets/lotti/moni_pod_wps_button.json": "325a6855551f93b08f537c42d83bf250",
"assets/assets/lotti/moni_router_wps_button.json": "1293e180b4839687d635c18fadde1264",
"assets/assets/lotti/moni_wps_button.json": "1293e180b4839687d635c18fadde1264",
"assets/assets/lotti/moni_wps_button_2.json": "a48d1e3cfbbed2dfd22c05f98c012cbb",
"assets/assets/lotti/motion_detected.json": "00e8338dc9bdb63451b894ffacdf0270",
"assets/assets/lotti/near_by_router.json": "90ec561b123bf4655bd1258bc73bbcb6",
"assets/assets/lotti/pairing_monipod.json": "97c1164df28c9a71c6eba169dfe9f924",
"assets/assets/lotti/pod_connecting_sucess_or_fail.json": "82fe4959d6cf8f15034f65e9d4facd8e",
"assets/assets/lotti/qr_code_scan.json": "c6736b9a965fb5f6d4c18ea3f5dca4a7",
"assets/assets/lotti/refresh_icon.json": "2314fdea0de097967ffec22b3ad64264",
"assets/assets/lotti/report_read.json": "5a682bab8bb0b1513fbd152dc093b45b",
"assets/assets/lotti/router_connecting.json": "192b5589982f041e67d08bb257dbee72",
"assets/assets/lotti/searching_for_network.json": "d8806e7f2bd0d3a084e8b4b89cae1bc8",
"assets/assets/lotti/searching_monipod.json": "074469c89acfeb0f14d355102837933b",
"assets/assets/lotti/sensing_bottom.json": "7336d035f335df370197e7e746654d7b",
"assets/assets/lotti/Sensitivity_Customed_Yellow.json": "81068b4cad8e4f9f549385c30eadd2e3",
"assets/assets/lotti/Sensitivity_High_Seat_Black.json": "49ed12de062687e815886e33871f44e0",
"assets/assets/lotti/Sensitivity_High_Seat_Yellow.json": "6257260822ff4f0c429306008c207cd6",
"assets/assets/lotti/Sensitivity_Low_Dance_Black.json": "2d2fb216aeb0a6cab37f008e2c67a4d7",
"assets/assets/lotti/Sensitivity_Low_Dance_Yellow.json": "15139416a54efab67388914cc83ab0dc",
"assets/assets/lotti/Sensitivity_Middle_Walk_Black.json": "fac408a31f96daa77ce6385009d3db71",
"assets/assets/lotti/Sensitivity_Middle_Walk_Yellow.json": "251d1f2596c9779ea0a8aa414865ebb8",
"assets/assets/prod.config.json": "f11130651af81d0b8678100d8bf88885",
"assets/assets/strings/en.json": "43cbdd01efc71f56ce42c1e3225cafbf",
"assets/assets/strings/ja.json": "b2ca02db583375d82646c43b4058b14a",
"assets/assets/strings/ko.json": "5d25965c549b3cc739971891d6fb90fc",
"assets/assets/strings/th.json": "757f0526cab569ff454c092d647d9320",
"assets/assets/strings/timezone_en.json": "8ce4da3016e20d466ffafe92ca1d7023",
"assets/assets/strings/timezone_ko.json": "707653cc258d11f5850b03bacad8d76f",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "4f97a119304f7665b4f6e3eb372dc721",
"assets/NOTICES": "1553c5490dea4c35fea5d3a666ab9e8b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "29b995c1f2e77da7c2f4f95e074922ad",
"flutter_config.yaml": "cff56e77686a5edda9f7dd78eb3a468a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "088002aa06491cc29065e30fe21fcbe5",
"/": "088002aa06491cc29065e30fe21fcbe5",
"main.dart.js": "4af24b427a91da5249c2127b72e2653f",
"manifest.json": "f603182fd52752c8a3e8db7ab7c277e0",
"splash/img/dark-1x.png": "5afad7830aa0751dee76f5138d51574a",
"splash/img/dark-2x.png": "93662de1fc15dc7bb9442d13a2a2aa4b",
"splash/img/dark-3x.png": "3458a1768858d8653f39f8fe4754b948",
"splash/img/dark-4x.png": "f8a9de89468144c0bc2bdd352255a140",
"splash/img/light-1x.png": "5afad7830aa0751dee76f5138d51574a",
"splash/img/light-2x.png": "93662de1fc15dc7bb9442d13a2a2aa4b",
"splash/img/light-3x.png": "3458a1768858d8653f39f8fe4754b948",
"splash/img/light-4x.png": "f8a9de89468144c0bc2bdd352255a140",
"version.json": "1b1bee02854ff6db9f6ec436f71682d9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
