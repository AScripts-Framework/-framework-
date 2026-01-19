# AS Framework Documentation

Official documentation website for AS Framework - A modern, optimized FiveM server framework.

## 🌐 Live Documentation

Visit [https://YOUR_USERNAME.github.io/as-framework](https://YOUR_USERNAME.github.io/as-framework) to view the live documentation.

## 📚 What's Included

This documentation covers all AS Framework resources:

- **AS-Core** - Framework foundation with player management, money system, and callbacks
- **AS-Spawn** - Multicharacter spawn system with appearance integration
- **AS-Target** - Custom raycast-based targeting with compatibility bridge
- **AS-HUD** - Modern purple-themed HUD with vehicle speedometer
- **AS-Fuel** - Comprehensive fuel and electric vehicle battery management
- **AS-AntiCheat** - Advanced cheat detection and prevention system
- **AS-Admin** - Full-featured admin menu with permission system

## 🚀 Features

- **Fully Responsive** - Optimized for desktop, tablet, and mobile devices
- **Interactive Navigation** - Easy-to-use sidebar (desktop) and tabs (mobile)
- **Code Examples** - Syntax-highlighted code snippets throughout
- **Modern Design** - Clean purple theme matching the framework
- **Fast Loading** - Static HTML/CSS/JS for instant page loads

## 🛠️ Local Development

To run the documentation locally:

1. Clone this repository
2. Open `index.html` in your web browser
3. No build process required!

```bash
git clone https://github.com/YOUR_USERNAME/as-framework.git
cd as-framework/docs
# Open index.html in your browser
```

## 📱 Mobile Friendly

The documentation is fully optimized for mobile devices with:
- Hamburger navigation menu
- Horizontal scrollable resource tabs
- Touch-friendly buttons and links
- Responsive layouts and typography
- Optimized spacing for small screens

## 🎨 Customization

### Changing Colors

Edit the CSS variables in `style.css`:

```css
:root {
    --purple: #8B5CF6;
    --purple-dark: #7C3AED;
    --purple-light: #A78BFA;
}
```

### Adding New Content

Update the documentation content in `script.js`:

```javascript
const docs = {
    'resource-name': `
    # Resource Name
    Your markdown content here...
    `
}
```

## 📄 File Structure

```
docs/
├── index.html          # Main HTML file
├── style.css           # Styling and responsive design
├── script.js           # Documentation content and functionality
└── README.md           # This file
```

## 🔗 Links

- [Framework Repository](https://github.com/YOUR_USERNAME/as-framework)
- [ox_lib Documentation](https://overextended.dev/ox_lib)
- [FiveM Documentation](https://docs.fivem.net)

## 📝 License

MIT License - See [LICENSE](../LICENSE) file for details

## 🤝 Contributing

Found a typo or want to improve the documentation? Feel free to submit a pull request!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/improved-docs`)
3. Commit your changes (`git commit -m 'Improve documentation'`)
4. Push to the branch (`git push origin feature/improved-docs`)
5. Open a Pull Request

---

Built with ❤️ for the FiveM community
