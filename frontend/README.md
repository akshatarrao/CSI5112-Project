# csi5112_project

## Getting Started

Please ensure your flutter version is `^2.10.0`

### Install

Ensure all dependencies are installed

```
flutter pub get
```

### Run

To run the application

```
flutter run
```

The default buyer user credential:
`admin@gmail.com:admin`

The default merchant user credential:
`merchant@gmail.com:merchant`,

### Development

All development code are under `./lib`.

`./lib/cpmponent` contains reusable cross-page component files

`./lib/dataModal` contains data structure files

`./lib/page` contains page implementation

To bypass login screen for faster development, flip `bypassLogin` and/or `bypassCustomer` in `./lib/login_screen`