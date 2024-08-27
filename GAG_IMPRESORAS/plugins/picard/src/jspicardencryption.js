function JSPicardEncryption() {
}

JSPicardEncryption.cardEncrypt = function (cardDetails, publicKeyB64) {
  try {
    var encrypt = new JSEncrypt();
    encrypt.setPublicKey(publicKeyB64);
    return encrypt.encrypt(JSON.stringify(cardDetails));
  }
  catch (ex) {
    return false;
  }
}

function JSCardUtils() {
}

JSCardUtils.luhnCheck = function (cardNumber) {
  var luhnArr = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9];
  var counter = 0;
  var incNum;
  var odd = false;
  var temp = String(cardNumber).replace(/[^\d]/g, "");
  if ( temp.length == 0)
    return false;
  for (var i = temp.length-1; i >= 0; --i) {
    incNum = parseInt(temp.charAt(i), 10);
    counter += (odd = !odd)? incNum : luhnArr[incNum];
  }
  return (counter%10 == 0);
}