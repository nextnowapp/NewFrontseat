//list for dropdown
final countries = [
  "South Africa",
  "Afghanistan",
  "Albania",
  "Algeria",
  "Andorra",
  "Angola",
  "Anguilla",
  "Antigua &amp; Barbuda",
  "Argentina",
  "Armenia",
  "Aruba",
  "Australia",
  "Austria",
  "Azerbaijan",
  "Bahamas",
  "Bahrain",
  "Bangladesh",
  "Barbados",
  "Belarus",
  "Belgium",
  "Belize",
  "Benin",
  "Bermuda",
  "Bhutan",
  "Bolivia",
  "Bosnia &amp; Herzegovina",
  "Botswana",
  "Brazil",
  "British Virgin Islands",
  "Brunei",
  "Bulgaria",
  "Burkina Faso",
  "Burundi",
  "Cambodia",
  "Cameroon",
  "Cape Verde",
  "Cayman Islands",
  "Chad",
  "Chile",
  "China",
  "Colombia",
  "Congo",
  "Cook Islands",
  "Costa Rica",
  "Cote D Ivoire",
  "Croatia",
  "Cruise Ship",
  "Cuba",
  "Cyprus",
  "Czech Republic",
  "Denmark",
  "Djibouti",
  "Dominica",
  "Dominican Republic",
  "Ecuador",
  "Egypt",
  "El Salvador",
  "Equatorial Guinea",
  "Estonia",
  "Ethiopia",
  "Falkland Islands",
  "Faroe Islands",
  "Fiji",
  "Finland",
  "France",
  "French Polynesia",
  "French West Indies",
  "Gabon",
  "Gambia",
  "Georgia",
  "Germany",
  "Ghana",
  "Gibraltar",
  "Greece",
  "Greenland",
  "Grenada",
  "Guam",
  "Guatemala",
  "Guernsey",
  "Guinea",
  "Guinea Bissau",
  "Guyana",
  "Haiti",
  "Honduras",
  "Hong Kong",
  "Hungary",
  "Iceland",
  "India",
  "Indonesia",
  "Iran",
  "Iraq",
  "Ireland",
  "Isle of Man",
  "Israel",
  "Italy",
  "Jamaica",
  "Japan",
  "Jersey",
  "Jordan",
  "Kazakhstan",
  "Kenya",
  "Kuwait",
  "Kyrgyz Republic",
  "Laos",
  "Latvia",
  "Lebanon",
  "Lesotho",
  "Liberia",
  "Libya",
  "Liechtenstein",
  "Lithuania",
  "Luxembourg",
  "Macau",
  "Macedonia",
  "Madagascar",
  "Malawi",
  "Malaysia",
  "Maldives",
  "Mali",
  "Malta",
  "Mauritania",
  "Mauritius",
  "Mexico",
  "Moldova",
  "Monaco",
  "Mongolia",
  "Montenegro",
  "Montserrat",
  "Morocco",
  "Mozambique",
  "Namibia",
  "Nepal",
  "Netherlands",
  "Netherlands Antilles",
  "New Caledonia",
  "New Zealand",
  "Nicaragua",
  "Niger",
  "Nigeria",
  "Norway",
  "Oman",
  "Pakistan",
  "Palestine",
  "Panama",
  "Papua New Guinea",
  "Paraguay",
  "Peru",
  "Philippines",
  "Poland",
  "Portugal",
  "Puerto Rico",
  "Qatar",
  "Reunion",
  "Romania",
  "Russia",
  "Rwanda",
  "Saint Pierre &amp; Miquelon",
  "Samoa",
  "San Marino",
  "Satellite",
  "Saudi Arabia",
  "Senegal",
  "Serbia",
  "Seychelles",
  "Sierra Leone",
  "Singapore",
  "Slovakia",
  "Slovenia",
  "South Korea",
  "Spain",
  "Sri Lanka",
  "St Kitts &amp; Nevis",
  "St Lucia",
  "St Vincent",
  "St. Lucia",
  "Sudan",
  "Suriname",
  "Swaziland",
  "Sweden",
  "Switzerland",
  "Syria",
  "Taiwan",
  "Tajikistan",
  "Tanzania",
  "Thailand",
  "Timor L'Este",
  "Togo",
  "Tonga",
  "Trinidad &amp; Tobago",
  "Tunisia",
  "Turkey",
  "Turkmenistan",
  "Turks &amp; Caicos",
  "Uganda",
  "Ukraine",
  "United Arab Emirates",
  "United Kingdom",
  "Uruguay",
  "Uzbekistan",
  "Venezuela",
  "Vietnam",
  "Virgin Islands (US)",
  "Yemen",
  "Zambia",
  "Zimbabwe"
];
const titles = ["Mr", "Miss", 'Mrs'];
const disability = ["Yes", "No"];
final gender = ['Male', 'Female', 'Others'];
final maritalStatus = ['Married', 'Single', 'Divorced', 'Widowed'];
final equity = ['African', 'Coloured', 'Indian', 'White'];
final province = [
  'Eastern Cape',
  'Free State',
  'Gauteng',
  'KwaZulu-Natal',
  'Limpopo',
  'Mpumalanga',
  'Northern Cape',
  'North West',
  'Western Cape'
];
final banks = [
  'ABSA BANK',
  'ACCESS BANK',
  'AFRICAN BANK',
  'ALBARAKA BANK',
  'BANK WINDHOEK',
  'BANK ZERO',
  'BIDVEST BANK',
  'BNP PARIBAS',
  'BOE BANK',
  'CAPITEC BANK LIMITED',
  'CITIBANK NA SOUTH AFRICA',
  'DISCOVERY BANK',
  'FINBOND MUTUAL BANK',
  'FINBOND NET1',
  'FIRST NATIONAL BANK (FNB)',
  'FIRST NATIONAL BANK LESOTHO',
  'FIRST NATIONAL BANK NAMIBIA',
  'FIRST NATIONAL BANK SWAZILAND',
  'GRINDROD BANK',
  'HABIB OVERSEAS BANK',
  'HBZ BANK',
  'HSBC BANK',
  'INVESTEC BANK',
  'ITHALA BANK',
  'JP MORGAN CHASE BANK',
  'MEEG BANK',
  'MERCANTILE BANK LIMITED',
  'NEDBANK',
  'NEDBANK LESOTHO ',
  'NEDBANK NAMIBIA',
  'NEDBANK SWAZILAND',
  'OLYMPUS MOBILE',
  'PEOPLES BANK LTD',
  'PEOPLES MORTGAGE LIMITED',
  'RESERVE BANK',
  'SASFIN BANK',
  'SOUTH AFRICAN POST OFFICE',
  'STANDARD BANK',
  'STANDARD BANK NAMIBIA',
  'STANDARD BANK SWAZILAND',
  'STANDARD CHARTERED BANK',
  'STANDARD LESOTHO BANK',
  "STATE BANK OF INDIA",
  'TYME BANK',
  'UBANK',
  'UNIBANK',
  'VBS MUTUAL'
];
final accountType = ['Savings', 'Current', 'Transmission'];
final accHolderRelationship = ['Own', 'Third Party', 'Joint'];

final pobox = ['Private Bag', 'Postnet Suite', 'Street Address', 'Others'];

final emergencyContactRelation = [
  'Father',
  'Mother',
  'Brother',
  'Sister',
  'Friend',
  'Husband',
  'Wife',
  'Neighbour',
  'Spouse',
  'Sibling',
  'Others'
];

final identityDocuments = [
  'National ID',
  'RSA ID',
  'Asylum Document',
  "Passport Document"
];

final cities = [
  "Alice",
"Butterworth",
"East London",
"Graaff-Reinet",
"Grahamstown",
"King William’s Town",
"Mthatha",
"Port Elizabeth",
"Queenstown",
"Uitenhage",
"Zwelitsha",
"Bethlehem",
"Bloemfontein",
"Jagersfontein",
"Kroonstad",
"Odendaalsrus",
"Parys",
"Phuthaditjhaba",
"Sasolburg",
"Virginia",
"Welkom",
"Benoni",
"Boksburg",
"Brakpan",
"Carletonville",
"Germiston",
"Johannesburg",
"Krugersdorp",
"Pretoria",
"Randburg",
"Randfontein",
"Roodepoort",
"Soweto",
"Springs",
"Vanderbijlpark",
"Vereeniging",
"Durban",
"Empangeni",
"Ladysmith",
"Newcastle",
"Pietermaritzburg",
"Pinetown",
"Ulundi",
"Umlazi",
"Giyani",
"Lebowakgomo",
"Musina",
"Phalaborwa",
"Polokwane",
"Seshego",
"Sibasa",
"Thabazimbi",
"Emalahleni",
"Nelspruit",
"Secunda",
"Klerksdorp",
"Mahikeng",
"Mmabatho",
"Potchefstroom",
"Rustenburg",
"Kimberley",
"Kuruman",
"Port Nolloth",
"Bellville",
"Cape Town",
"Constantia",
"George",
"Hopefield",
"Oudtshoorn",
"Paarl",
"Simon’s Town",
"Stellenbosch",
"Swellendam",
"Worcester",
];
