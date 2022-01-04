class Strings {
  // Titles
  static const title = 'Anchr';
  static const titleAddNewLinkPage = 'Add new link';
  static const titleCollectionPage = 'Collection';
  static const titleLoginPage = 'Log In';
  static const titleLogsPage = 'Logs';
  static const titleAboutPage = 'About & Privacy';
  static const titleLicensesPage = 'Open-Source Licenses';
  static const titleNewCollectionDialog = 'New Collection';
  static const titleDeleteLinkDialog = 'Delete link?';
  static const titleDeleteCollectionDialog = 'Delete collection?';
  static const titleDrawer = 'Collections';

  // Text labels
  static const labelCollectionInput = 'Collection';
  static const labelLinkInput = 'Link';
  static const labelLinkInputHint = 'E.g. https://duckduckgo.com';
  static const labelServerInput = 'Server URL';
  static const labelServerInputHint = 'E.g. https://example.org/';
  static const labelEmailInput = 'E-Mail';
  static const labelEmailInputHint = 'E.g. you@example.org';
  static const labelCollectionNameInput = 'Collection Name';
  static const labelCollectionNameInputHint = 'Name';
  static const labelPasswordInput = 'Password';
  static const labelLinkDescriptionInput = 'Description';
  static const labelLinkDescriptionInputHint = 'Describe the link';
  static const labelSaveButton = 'Save';
  static const labelAddButton = 'Add';
  static const labelDeleteButton = 'Delete Link';
  static const labelCopyButton = 'Copy Link';
  static const labelShareButton = 'Share Link';
  static const labelDeleteCollectionButton = 'Delete Collection';
  static const labelLoginButton = 'Login';
  static const labelLogoutButton = 'Logout';
  static const labelCancelButton = 'Cancel';
  static const labelYesButton = 'Yes';
  static const labelAddCollectionButton = 'Add collection';
  static const labelNoLinkDescription = '<no description>';
  static const labelNoData = 'No Data :\'-(';
  static const labelLoading = 'Loading ...';
  static const labelRefreshButton = 'Refresh';
  static const labelLogsButton = 'Logs';
  static const labelAboutButton = 'About & Privacy';
  static const labelLicensesButton = 'Licenses';
  static const labelViewCodeButton = 'View source code';
  static const labelViewLegal = 'View legal statement & privacy';
  static const labelCustomLicense = 'Custom License';

  // Alert messages
  static const msgCollectionAdded = 'Collection added';
  static const msgCollectionDeleted = 'Collection deleted';
  static const msgLinkDeleted = 'Link deleted';
  static const msgLinkAdded = 'Link added';
  static const msgChooseCollectionName = 'Please choose a name for the new collection.';
  static const msgConfirmDeleteLink = 'Are you sure you want to delete this link from the collection?';
  static const msgConfirmDeleteCollection = 'Are you sure you want to delete this collection?';
  static const msgSignUp = '💡 You need to have your own self-hosted instance of Anchr as well as a registered account. For more information, see';
  static const msgLinkCopied = 'Copied to clipboard';
  static const msgCopyLogs = 'Below are the latest (past 7 days) logs from this application. They can be used for debugging purposes when posted to GitHub. Long-press to select and copy them.';

  // Error messages
  static const errorLoadCollections = 'Failed to load collections';
  static const errorLoadCollection = 'Failed to load collection';
  static const errorAddCollection = 'Failed to add collection';
  static const errorAddLink = 'Failed to add link';
  static const errorDeleteLink = 'Failed to delete link';
  static const errorInvalidUrl = 'Not a valid URL.';
  static const errorInvalidEmail = 'Not a valid e-mail address.';
  static const errorNoPassword = 'Please enter a password.';
  static const errorLogin = 'Failed to log in. Something went wrong.';
  static const errorLoginUnauthorized = 'Failed to log in. Is your password correct?';
  static const errorLoginNoConnection = 'Failed to log in. Could not resolve host.';
  static const errorInvalidName = 'Name not valid or already existing';

  // Keys
  static const keySharedLinkUrl = 'text';
  static const keySharedLinkTitle = 'subject';
  static const keyLastActiveCollectionPref = 'collection.last_active';
  static const keyUserServerPref = 'user.api_url';
  static const keyUserTokenPref = 'user.token';
  static const keyUserMailPref = 'user.mail';
  static const keyDbCollections = 'collection.db';
  static const keyDbLinks = 'link.db';
  static const keyCollectionsEtag = 'etag.collections';
  static const keyCollectionEtagPrefix = 'etag.collection.';

  // Other
  static const urlAnchrGithub = 'https://github.com/muety/anchr';
  static const urlGithub = 'https://github.com/muety/anchr-android';
  static const urlLegal = 'https://anchr.io/#/terms';

  // Texts
  static const txtAbout = '''
  Anchr for Android was created by Ferdinand Mütsch (ferdinand@muetsch.io) in 2019 as a private, non-profit open-source project. It is able to consum a self-hosted version of the web service https://github.com/muety/anchr, whose URL / host name is specified during log in. The service's source code is open to the public.
  
  Ferdinand Mütsch, developer and maintainer of this mobile application, does not take responsibility for content that is shared through it by any user.
  ''';

  static const txtLicensesIntro = '''
  This project is published under the "GNU General Public License v3.0" and uses the following third-party open-source software. Licenses can be viewed by clicking the respective hyperlink. Nested dependencies are not listed here, since every third-party project is responsible for adhering to its license by itself. 
  ''';
}
