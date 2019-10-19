class Strings {
  // Titles
  static const title = 'Anchr.io';
  static const titleAddNewLinkPage = 'Add new link';
  static const titleCollectionPage = 'Collection';
  static const titleLoginPage = 'Log In';
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
  static const labelEmailInput = 'E-Mail';
  static const labelEmailInputHint = 'E.g. you@example.org';
  static const labelCollectionNameInput = 'Collection Name';
  static const labelCollectionNameInputHint = 'Name';
  static const labelPasswordInput = 'Password';
  static const labelLinkDescriptionInput = 'Description';
  static const labelLinkDescriptionInputHint = 'Describe the link';
  static const labelSaveButton = 'Save';
  static const labelAddButton = 'Add';
  static const labelDeleteButton = 'Delete';
  static const labelCopyButton = 'Copy Link';
  static const labelLoginButton = 'Login';
  static const labelLogoutButton = 'Logout';
  static const labelCancelButton = 'Cancel';
  static const labelYesButton = 'Yes';
  static const labelAddCollectionButton = 'Add collection';
  static const labelNoLinkDescription = '<no description>';
  static const labelNoData = 'No Data :\'-(';
  static const labelLoading = 'Loading ...';
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
  static const msgSignUp = '💡 If you do not have an Anchr account, yet, please sign up at';
  static const msgLinkCopied = 'Copied to clipboard';

  // Error messages
  static const errorLoadCollections = 'Failed to load collections';
  static const errorLoadCollection = 'Failed to load collection';
  static const errorAddCollection = 'Failed to add collection';
  static const errorAddLink = 'Failed to add link';
  static const errorDeleteLink = 'Failed to delete link';
  static const errorInvalidUrl = 'Not a valid URL.';
  static const errorInvalidEmail = 'Not a valid e-mail address.';
  static const errorNoPassword = 'Please enter a password.';
  static const errorLogin = 'Failed to log in. Is your password correct?';
  static const errorInvalidName = 'Name not valid or already existing';

  // Keys
  static const keySharedLinkUrl = 'text';
  static const keySharedLinkTitle = 'subject';
  static const keyLastActiveCollectionPref = 'collection.last_active';
  static const keyUserTokenPref = 'user.token';
  static const keyUserMailPref = 'user.mail';
  static const keyDbCollections = 'collection.db';
  static const keyDbLinks = 'link.db';
  static const keyCollectionsEtag = 'etag.collections';
  static const keyCollectionEtagPrefix = 'etag.collection.';

  // Other
  static const urlAnchr = 'https://anchr.io';
  static const urlGithub = 'https://github.com/n1try/anchr-android';
  static const urlLegal = 'https://anchr.io/#/terms';

  // Texts
  static const txtAbout = '''
  Anchr for Android was created by Ferdinand Mütsch (mail@ferdinand-muetsch.de) in 2019 as a private, non-profit open-source project. It consumes the web service available at anchr.io, which is open-source and free to use as well.
  
  All technical infrastructure is operated by Ferdinand Mütsch, however, he does not take responsibility for content that is shared through this service by a user.
  ''';

  static const txtLicensesIntro = '''
  This project is published under the "GNU General Public License v3.0" and uses the following third-party open-source software. Licenses can be viewed by clicking the respective hyperlink. Nested dependencies are not listed here, since every third-party project is responsible for adhering to its license by itself. 
  ''';
}
