enum Gender { Male, Female }

Gender stringToGender(String gender) {
  switch (gender) {
    case "M":
      return Gender.Male;
    case "F":
      return Gender.Female;
    default:
      return Gender.Male;
  }
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.Male:
      return "M";
    case Gender.Female:
      return "F";
    default:
      return "M";
  }
}

enum ImageType { NETWORK, FILE, ASSETS }
