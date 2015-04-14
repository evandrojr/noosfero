function oauthPluginCloseLoginPopup(loggedIn) {
  if (window.opener && typeof window.opener.handleLoginResult == 'function') {
    try {
      window.opener.handleLoginResult(loggedIn);
    } catch (err) {}
    window.close();
  }
  return false;
}
