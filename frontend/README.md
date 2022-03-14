# csi5112_project frontend

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

### Test

Due to the poor choice of using flutter_login package, we are not able to test the login page. However, 
the package itself is [tested](https://github.com/NearHuscarl/flutter_login/tree/master/test).

* The Item list page and order history page is tested via "buy an apple" workflow in `./test/integration_test/app_test_buyer.dart`
* The Product setup page is tested in `./test/integration_test/app_test_merchant.dart`
* The Question/Answer Forum is tested in `./test/page/answer_page_test.dart` and `./test/page/discussion_forum_test.dart` as unit tests (They were created early)
* The navigation between pages are also tested in `./test/integration_test/app_test_buyer.dart` and `./test/integration_test/app_test_merchant.dart`

Therefore, the project has test coverage for all pages in some format. In addition, most of the API endpoints are tested separately in `../backend_test` project. 

#### Unit Test
Use the below command to run unit tests
```
flutter tests
```

#### Integration Test
Update to code in `./login_screen.dart` to enable 
```
  bool bypassLogin = true;
  bool bypassCustomer = true/false;
```

Follow [link](https://chromedriver.chromium.org/downloads) to install chrome driver

Run [backend code](https://github.com/akshatarrao/CSI5112-Project/tree/development/backend)

Run `chromedriver --port=4444`

Run 
```
flutter drive   --driver=test/test_driver/integration_test.dart   --target=test/integration_test/app_test_buyer.dart   -d web-server
flutter drive   --driver=test/test_driver/integration_test.dart   --target=test/integration_test/app_test_merchant.dart   -d web-server
```


# References
1. https://github.com/NearHuscarl/flutter_login
2. https://github.com/umangce/sliding-nav-bar
3. https://docs.flutter.dev/cookbook/testing/integration/introduction