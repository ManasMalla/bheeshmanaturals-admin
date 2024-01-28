import 'package:bheeshma_naturals_admin/data/providers/address_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/advertisement_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/category_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/coupon_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/notification_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/order_provider.dart';
import 'package:bheeshma_naturals_admin/data/providers/product_provider.dart';
import 'package:bheeshma_naturals_admin/presentation/dashboard.dart';
import 'package:bheeshma_naturals_admin/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AdvertisementProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Bheeshma Naturals | Admin',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF80893A), background: Colors.white),
          useMaterial3: true,
          fontFamily: 'Gilroy',
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF80893A),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: 'Gilroy',
          brightness: Brightness.dark,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) =>
              const MyHomePage(title: 'Bheeshma Naturals | Admin'),
          '/dashboard': (context) => const DashboardPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool obscureText = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (FirebaseAuth.instance.currentUser != null) {
        fetchDetails(context).then((value) {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Container(
          width: 500,
          child: Image.asset(
            'assets/images/skincare.png',
            fit: BoxFit.fitHeight,
            height: double.infinity,
            alignment: Alignment.centerLeft,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 48.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/bheeshma-naturals.svg',
                  height: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                  'Login'.toUpperCase(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Everything naturals at one place'.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                      filled: true,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 24,
                ),
                FilledButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: usernameController.text,
                            password: passwordController.text)
                        .then((value) {
                      Navigator.of(context).pushReplacementNamed('/dashboard');
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> fetchDetails(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Fetching details...'),
    ));
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final advertisementProvider =
        Provider.of<AdvertisementProvider>(context, listen: false);
    final couponProvider = Provider.of<CouponProvider>(context, listen: false);
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);
    await categoryProvider.fetchCategories().then((_) async {
      await categoryProvider.fetchSubcategories().then((_) async {
        await productProvider
            .fetchProducts(
                categoryProvider.categories, categoryProvider.subcategories)
            .then((_) async {
          await advertisementProvider.fetchAdvertisements().then((_) async {
            await notificationProvider.fetchNotification().then((_) async {
              await couponProvider.fetchCoupons().then((_) async {
                await orderProvider.fetchOrders();
              });
            });
          });
        });
      });
    });
  }
}
