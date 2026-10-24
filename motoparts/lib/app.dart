import 'package:flutter/material.dart';

const _background = Color(0xFF071426);
const _surface = Color(0xFF10233B);
const _surfaceLight = Color(0xFF18314F);
const _blue = Color(0xFF3988FF);
const _mint = Color(0xFF55D6BE);
const _muted = Color(0xFF8FA4BE);
const _white = Color(0xFFF3F7FC);

class MotoPartsApp extends StatelessWidget {
  const MotoPartsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MotoParts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _background,
        colorScheme: const ColorScheme.dark(
          primary: _blue,
          secondary: _mint,
          surface: _surface,
          onSurface: _white,
        ),
        fontFamily: 'Roboto',
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _surface,
          hintStyle: const TextStyle(color: _muted),
          labelStyle: const TextStyle(color: _muted),
          prefixIconColor: _muted,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 17,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF203955)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _blue, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6B77)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFFF6B77)),
          ),
        ),
      ),
      home: const _AppEntry(),
    );
  }
}

class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _signedIn = false;
  String _name = 'Raka Pratama';
  String _email = 'raka@email.com';
  String _password = '';

  void _signIn(String email, String password) {
    if (_password.isNotEmpty && (email != _email || password != _password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password tidak sesuai.')),
      );
      return;
    }
    setState(() {
      _email = email;
      _name = email
          .split('@')
          .first
          .split(RegExp(r'[._-]'))
          .map(
            (word) => word.isEmpty
                ? word
                : '${word[0].toUpperCase()}${word.substring(1)}',
          )
          .join(' ');
      _password = password;
      _signedIn = true;
    });
  }

  void _register(String name, String email, String password) {
    setState(() {
      _name = name;
      _email = email;
      _password = password;
      _signedIn = true;
    });
  }

  void _signOut() {
    setState(() => _signedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_signedIn) {
      return DashboardPage(
        name: _name,
        email: _email,
        currentPassword: _password,
        onSignOut: _signOut,
        onPasswordChanged: (password) {
          _password = password;
        },
      );
    }
    return LoginPage(
      initialEmail: _email,
      onSignIn: _signIn,
      onRegister: _register,
      onPasswordChanged: (password) {
        _password = password;
      },
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    required this.initialEmail,
    required this.onSignIn,
    required this.onRegister,
    required this.onPasswordChanged,
    super.key,
  });

  final String initialEmail;
  final void Function(String email, String password) onSignIn;
  final void Function(String name, String email, String password) onRegister;
  final ValueChanged<String> onPasswordChanged;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController = TextEditingController(
    text: widget.initialEmail,
  );
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(),
            const SizedBox(height: 46),
            const Text(
              'Selamat datang\nkembali.',
              style: TextStyle(
                color: _white,
                fontSize: 34,
                height: 1.12,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Masuk untuk mengelola toko dan kebutuhan\nspare part motor Anda.',
              style: TextStyle(color: _muted, height: 1.5),
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nama@email.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Password wajib diisi'
                  : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => _openPasswordPage(context),
                child: const Text('Lupa password?'),
              ),
            ),
            const SizedBox(height: 10),
            PrimaryButton(label: 'Masuk', onPressed: _submit),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Belum punya akun? ',
                    style: TextStyle(color: _muted),
                  ),
                  TextButton(
                    onPressed: () => _openRegisterPage(context),
                    child: const Text('Daftar sekarang'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSignIn(_emailController.text.trim(), _passwordController.text);
    }
  }

  void _openRegisterPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RegisterPage(onRegister: widget.onRegister),
      ),
    );
  }

  void _openPasswordPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PasswordPage(
          email: _emailController.text.trim(),
          onPasswordChanged: widget.onPasswordChanged,
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({required this.onRegister, super.key});

  final void Function(String name, String email, String password) onRegister;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(),
            const SizedBox(height: 38),
            const Text(
              'Buat akun baru',
              style: TextStyle(
                color: _white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mulai kelola spare part dengan lebih mudah.',
              style: TextStyle(color: _muted),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nama lengkap',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama wajib diisi'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'nama@email.com',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => value == null || value.length < 8
                  ? 'Gunakan minimal 8 karakter'
                  : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi password',
                prefixIcon: Icon(Icons.verified_user_outlined),
              ),
              validator: (value) => value != _passwordController.text
                  ? 'Konfirmasi password belum cocok'
                  : null,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Buat akun', onPressed: _submit),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'Dengan mendaftar, Anda menyetujui ketentuan penggunaan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onRegister(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      Navigator.of(context).pop();
    }
  }
}

class PasswordPage extends StatefulWidget {
  const PasswordPage({
    required this.email,
    required this.onPasswordChanged,
    this.currentPassword,
    super.key,
  });

  final String email;
  final ValueChanged<String> onPasswordChanged;
  final String? currentPassword;

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandMark(),
            const SizedBox(height: 42),
            const Text(
              'Atur password',
              style: TextStyle(
                color: _white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.email.isEmpty
                  ? 'Buat password baru untuk akun Anda.'
                  : 'Perbarui password untuk ${widget.email}.',
              style: const TextStyle(color: _muted, height: 1.5),
            ),
            const SizedBox(height: 30),
            if (widget.currentPassword != null) ...[
              _passwordField(
                controller: _currentController,
                label: 'Password saat ini',
                isRequired: true,
                mustMatch: widget.currentPassword,
              ),
              const SizedBox(height: 14),
            ],
            _passwordField(
              controller: _newController,
              label: 'Password baru',
              isRequired: true,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _confirmController,
              obscureText: _obscure,
              decoration: InputDecoration(
                labelText: 'Konfirmasi password baru',
                prefixIcon: const Icon(Icons.verified_user_outlined),
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => value != _newController.text
                  ? 'Konfirmasi password belum cocok'
                  : null,
            ),
            const SizedBox(height: 24),
            PrimaryButton(label: 'Simpan password', onPressed: _submit),
            const SizedBox(height: 14),
            const Text(
              'Gunakan minimal 8 karakter untuk menjaga keamanan akun.',
              style: TextStyle(color: _muted, fontSize: 12, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool isRequired,
    String? mustMatch,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
        ),
      ),
      validator: (value) {
        if (!isRequired && (value == null || value.isEmpty)) return null;
        if (value == null || value.length < 8) {
          return 'Gunakan minimal 8 karakter';
        }
        if (mustMatch != null && value != mustMatch) {
          return 'Password saat ini tidak sesuai';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onPasswordChanged(_newController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui.')),
      );
      Navigator.of(context).pop();
    }
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    required this.name,
    required this.email,
    required this.currentPassword,
    required this.onSignOut,
    required this.onPasswordChanged,
    super.key,
  });

  final String name;
  final String email;
  final String currentPassword;
  final VoidCallback onSignOut;
  final ValueChanged<String> onPasswordChanged;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late String _currentPassword;

  static const _titles = ['Beranda', 'Produk', 'Pesanan', 'Profil'];

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.currentPassword;
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;
    final pages = [
      _HomeContent(name: widget.name, onNavigate: _selectPage),
      const _ProductsContent(),
      const _OrdersContent(),
      _ProfileContent(
        name: widget.name,
        email: widget.email,
        onSignOut: widget.onSignOut,
        onChangePassword: _openPasswordPage,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _background,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 20,
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(
            color: _white,
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Notifikasi',
            onPressed: () => _showMessage('Belum ada notifikasi baru.'),
            icon: const Icon(Icons.notifications_none_rounded, color: _white),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              backgroundColor: _background,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectPage,
              labelType: NavigationRailLabelType.all,
              groupAlignment: -0.8,
              leading: const Padding(
                padding: EdgeInsets.only(bottom: 28, top: 12),
                child: BrandMark(compact: true),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: Text('Beranda'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: Text('Produk'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  label: Text('Pesanan'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  label: Text('Profil'),
                ),
              ],
            ),
          if (wide) const VerticalDivider(width: 1, color: Color(0xFF1B3049)),
          Expanded(
            child: SafeArea(
              top: false,
              child: IndexedStack(index: _selectedIndex, children: pages),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _selectPage,
              backgroundColor: _surface,
              indicatorColor: _blue.withValues(alpha: 0.2),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'Beranda',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: 'Produk',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  label: 'Pesanan',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'Profil',
                ),
              ],
            ),
    );
  }

  void _selectPage(int index) => setState(() => _selectedIndex = index);

  void _openPasswordPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PasswordPage(
          email: widget.email,
          currentPassword: _currentPassword,
          onPasswordChanged: (password) {
            setState(() => _currentPassword = password);
            widget.onPasswordChanged(password);
          },
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.name, required this.onNavigate});

  final String name;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final firstName = name.split(' ').first;
    return _PageScroll(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF153B68), Color(0xFF10233B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF25496F)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SENIN, 24 OKTOBER 2026',
                style: TextStyle(
                  color: Color(0xFF9EC5FA),
                  fontSize: 11,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Halo, $firstName 👋',
                style: const TextStyle(
                  color: _white,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ini ringkasan toko Anda hari ini. Semoga aktivitasnya lancar!',
                style: TextStyle(color: Color(0xFFB4C8DF), height: 1.5),
              ),
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: () => onNavigate(1),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Kelola produk'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _white,
                  side: const BorderSide(color: Color(0xFF658BB4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        const _SectionHeading(title: 'Ringkasan toko', subtitle: 'Hari ini'),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 700 ? 4 : 2;
            return GridView.count(
              crossAxisCount: columns,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: constraints.maxWidth > 700 ? 1.5 : 1.3,
              children: const [
                _StatCard(
                  icon: Icons.payments_outlined,
                  title: 'Penjualan',
                  value: 'Rp 4,8 jt',
                  trend: '+12,5%',
                  color: _mint,
                ),
                _StatCard(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Pesanan',
                  value: '28',
                  trend: '+8 hari ini',
                  color: _blue,
                ),
                _StatCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Produk',
                  value: '146',
                  trend: '8 stok rendah',
                  color: Color(0xFFFFC66D),
                ),
                _StatCard(
                  icon: Icons.people_outline_rounded,
                  title: 'Pelanggan',
                  value: '92',
                  trend: '+6 minggu ini',
                  color: Color(0xFFC39BFF),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 28),
        _SectionHeading(
          title: 'Pesanan terbaru',
          subtitle: 'Lihat semua',
          onTap: () => onNavigate(2),
        ),
        const SizedBox(height: 12),
        const _RecentOrder(
          initials: 'AP',
          name: 'Andi Pratama',
          detail: 'Oli mesin Motul 10W-40 · 2 item',
          amount: 'Rp 285.000',
          status: 'Diproses',
          statusColor: _blue,
        ),
        const _RecentOrder(
          initials: 'DS',
          name: 'Dewi Santoso',
          detail: 'Kampas rem depan · 1 item',
          amount: 'Rp 125.000',
          status: 'Selesai',
          statusColor: _mint,
        ),
        const _RecentOrder(
          initials: 'BF',
          name: 'Bima Firmansyah',
          detail: 'Rantai motor · 1 item',
          amount: 'Rp 198.000',
          status: 'Menunggu',
          statusColor: Color(0xFFFFC66D),
        ),
      ],
    );
  }
}

class _ProductsContent extends StatelessWidget {
  const _ProductsContent();

  static const _products = [
    (
      'Oli Mesin Motul 10W-40',
      'OLI-001',
      'Rp 145.000',
      '32 stok',
      Icons.oil_barrel_outlined,
    ),
    (
      'Kampas Rem Depan',
      'REM-014',
      'Rp 125.000',
      '18 stok',
      Icons.settings_outlined,
    ),
    (
      'Busi NGK Iridium',
      'BUS-008',
      'Rp 85.000',
      '4 stok',
      Icons.electric_bolt_rounded,
    ),
    (
      'Rantai Motor DID 428',
      'RNT-020',
      'Rp 198.000',
      '12 stok',
      Icons.link_rounded,
    ),
    (
      'Filter Udara Universal',
      'FLT-003',
      'Rp 72.000',
      '26 stok',
      Icons.air_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _PageScroll(
      children: [
        const _SectionHeading(
          title: 'Katalog produk',
          subtitle: '146 produk tersedia',
        ),
        const SizedBox(height: 18),
        TextField(
          decoration: InputDecoration(
            hintText: 'Cari nama atau kode produk',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              tooltip: 'Filter',
              onPressed: () {},
              icon: const Icon(Icons.tune_rounded),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._products.map(
          (product) => _ProductTile(
            icon: product.$5,
            name: product.$1,
            code: product.$2,
            price: product.$3,
            stock: product.$4,
            lowStock: product.$4.startsWith('4'),
          ),
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Tambah produk',
          icon: Icons.add_rounded,
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Form tambah produk siap dihubungkan.'),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    return _PageScroll(
      children: [
        const _SectionHeading(
          title: 'Semua pesanan',
          subtitle: '28 pesanan hari ini',
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Semua', 'Diproses', 'Menunggu', 'Selesai']
              .map(
                (label) => Chip(
                  label: Text(label),
                  backgroundColor: label == 'Semua'
                      ? _blue.withValues(alpha: 0.25)
                      : _surface,
                  side: BorderSide(
                    color: label == 'Semua'
                        ? _blue.withValues(alpha: 0.6)
                        : const Color(0xFF203955),
                  ),
                  labelStyle: TextStyle(
                    color: label == 'Semua' ? _white : _muted,
                    fontSize: 12,
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        const _RecentOrder(
          initials: 'AP',
          name: 'Andi Pratama',
          detail: 'MP-2026-1024 · 2 item · 09:42',
          amount: 'Rp 285.000',
          status: 'Diproses',
          statusColor: _blue,
        ),
        const _RecentOrder(
          initials: 'DS',
          name: 'Dewi Santoso',
          detail: 'MP-2026-1023 · 1 item · 09:18',
          amount: 'Rp 125.000',
          status: 'Selesai',
          statusColor: _mint,
        ),
        const _RecentOrder(
          initials: 'BF',
          name: 'Bima Firmansyah',
          detail: 'MP-2026-1022 · 1 item · 08:56',
          amount: 'Rp 198.000',
          status: 'Menunggu',
          statusColor: Color(0xFFFFC66D),
        ),
        const _RecentOrder(
          initials: 'NA',
          name: 'Nina Amelia',
          detail: 'MP-2026-1021 · 3 item · 08:31',
          amount: 'Rp 412.000',
          status: 'Selesai',
          statusColor: _mint,
        ),
      ],
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({
    required this.name,
    required this.email,
    required this.onSignOut,
    required this.onChangePassword,
  });

  final String name;
  final String email;
  final VoidCallback onSignOut;
  final VoidCallback onChangePassword;

  @override
  Widget build(BuildContext context) {
    return _PageScroll(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF203955)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: _blue.withValues(alpha: 0.2),
                child: Text(
                  _initials(name),
                  style: const TextStyle(
                    color: Color(0xFF9EC5FA),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: _white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(email, style: const TextStyle(color: _muted)),
                  ],
                ),
              ),
              const Icon(Icons.verified_rounded, color: _mint, size: 21),
            ],
          ),
        ),
        const SizedBox(height: 26),
        const _SectionHeading(title: 'Pengaturan akun'),
        const SizedBox(height: 12),
        _SettingsTile(
          icon: Icons.lock_reset_rounded,
          title: 'Ubah password',
          subtitle: 'Perbarui keamanan akun Anda',
          onTap: onChangePassword,
        ),
        _SettingsTile(
          icon: Icons.storefront_outlined,
          title: 'Informasi toko',
          subtitle: 'MotoParts Jakarta',
          onTap: () => _showMessage(context, 'Informasi toko'),
        ),
        _SettingsTile(
          icon: Icons.help_outline_rounded,
          title: 'Pusat bantuan',
          subtitle: 'Kami siap membantu Anda',
          onTap: () => _showMessage(context, 'Pusat bantuan'),
        ),
        const SizedBox(height: 22),
        OutlinedButton.icon(
          onPressed: () => _confirmSignOut(context),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Keluar dari akun'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFFF8790),
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: Color(0xFF643340)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _surface,
        title: const Text('Keluar dari akun?'),
        content: const Text(
          'Anda perlu masuk kembali untuk membuka dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onSignOut();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$message belum tersedia.')));
  }
}

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.child,
    this.showBackButton = false,
    super.key,
  });

  final Widget child;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned(
            top: -110,
            right: -110,
            child: _GlowCircle(size: 300, color: Color(0xFF123A69)),
          ),
          const Positioned(
            bottom: -180,
            left: -140,
            child: _GlowCircle(size: 350, color: Color(0xFF102B4A)),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 470),
                child: Column(
                  children: [
                    if (showBackButton)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Kembali',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(26, 22, 26, 24),
                        child: child,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        'MOTOPARTS  •  PARTNER PERJALANAN ANDA',
                        style: TextStyle(
                          color: Color(0xFF637A96),
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BrandMark extends StatelessWidget {
  const BrandMark({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 38.0 : 48.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_blue, Color(0xFF65B4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(compact ? 12 : 15),
            boxShadow: [
              BoxShadow(
                color: _blue.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            Icons.settings_rounded,
            color: Colors.white,
            size: compact ? 22 : 27,
          ),
        ),
        const SizedBox(width: 12),
        if (!compact)
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOTOPARTS',
                style: TextStyle(
                  color: _white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.4,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'SPARE PARTS MANAGEMENT',
                style: TextStyle(color: _muted, fontSize: 9, letterSpacing: 1),
              ),
            ],
          ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 19),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

class _PageScroll extends StatelessWidget {
  const _PageScroll({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, this.subtitle, this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              subtitle!,
              style: TextStyle(
                color: onTap == null ? _muted : const Color(0xFF80B5FF),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.trend,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final String trend;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: const Color(0xFF203955)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              color: _white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            trend,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _RecentOrder extends StatelessWidget {
  const _RecentOrder({
    required this.initials,
    required this.name,
    required this.detail,
    required this.amount,
    required this.status,
    required this.statusColor,
  });

  final String initials;
  final String name;
  final String detail;
  final String amount;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF203955)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: _surfaceLight,
            child: Text(
              initials,
              style: const TextStyle(
                color: Color(0xFF9EC5FA),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(height: 7),
                Text(
                  amount,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.icon,
    required this.name,
    required this.code,
    required this.price,
    required this.stock,
    required this.lowStock,
  });

  final IconData icon;
  final String name;
  final String code;
  final String price;
  final String stock;
  final bool lowStock;

  @override
  Widget build(BuildContext context) {
    final stockColor = lowStock
        ? const Color(0xFFFFC66D)
        : const Color(0xFF79D9C7);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF203955)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _blue.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: const Color(0xFF82B7FF), size: 22),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: _white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$code  ·  $stock',
                  style: TextStyle(color: stockColor, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            price,
            style: const TextStyle(
              color: _white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _blue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF82B7FF), size: 21),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: _white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: _muted, fontSize: 11),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: _muted),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      tileColor: _surface,
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withValues(alpha: 0.6), color.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email wajib diisi';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Masukkan alamat email yang valid';
  }
  return null;
}

String _initials(String name) {
  final words = name.trim().split(RegExp(r'\s+'));
  if (words.length == 1) return words.first.substring(0, 1).toUpperCase();
  return '${words.first.substring(0, 1)}${words.last.substring(0, 1)}'
      .toUpperCase();
}
