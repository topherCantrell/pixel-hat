package pixelHat;

import java.util.ArrayList;
import java.util.List;

public class HatFrame {
	
	// 1831
	
	int [] topEdges = new int[27+27];
	int [] topRing  = new int[241];
	
	int [] sideBrim = new int[256*6];
		
	// 35 rings
	// 64 lines	
	
	static final int[][] RINGS = {
		{-1},
		{-1},
		{-1},
		{-1},
		{-1},
		{-1},
		{-1},
		{-1},
		{-1},
		//
		{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63},
		{64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127},
		{128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191},
		{192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255},
		{256,257,258,259,260,261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319},
		{320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383},
		{384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,444,445,446,447},
		{448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,510,511},
		{512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575},
		{576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,598,599,600,601,602,603,604,605,606,607,608,609,610,611,612,613,614,615,616,617,618,619,620,621,622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,637,638,639},
		{640,641,642,643,644,645,646,647,648,649,650,651,652,653,654,655,656,657,658,659,660,661,662,663,664,665,666,667,668,669,670,671,672,673,674,675,676,677,678,679,680,681,682,683,684,685,686,687,688,689,690,691,692,693,694,695,696,697,698,699,700,701,702,703},
		{704,705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,721,722,723,724,725,726,727,728,729,730,731,732,733,734,735,736,737,738,739,740,741,742,743,744,745,746,747,748,749,750,751,752,753,754,755,756,757,758,759,760,761,762,763,764,765,766,767},
		{768,769,770,771,772,773,774,775,776,777,778,779,780,781,782,783,784,785,786,787,788,789,790,791,792,793,794,795,796,797,798,799,800,801,802,803,804,805,806,807,808,809,810,811,812,813,814,815,816,817,818,819,820,821,822,823,824,825,826,827,828,829,830,831},
		{832,833,834,835,836,837,838,839,840,841,842,843,844,845,846,847,848,849,850,851,852,853,854,855,856,857,858,859,860,861,862,863,864,865,866,867,868,869,870,871,872,873,874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895},
		{896,897,898,899,900,901,902,903,904,905,906,907,908,909,910,911,912,913,914,915,916,917,918,919,920,921,922,923,924,925,926,927,928,929,930,931,932,933,934,935,936,937,938,939,940,941,942,943,944,945,946,947,948,949,950,951,952,953,954,955,956,957,958,959},
		{960,961,962,963,964,965,966,967,968,969,970,971,972,973,974,975,976,977,978,979,980,981,982,983,984,985,986,987,988,989,990,991,992,993,994,995,996,997,998,999,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023},
		{1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,1035,1036,1037,1038,1039,1040,1041,1042,1043,1044,1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1062,1063,1064,1065,1066,1067,1068,1069,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087},
		{1088,1089,1090,1091,1092,1093,1094,1095,1096,1097,1098,1099,1100,1101,1102,1103,1104,1105,1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1118,1119,1120,1121,1122,1123,1124,1125,1126,1127,1128,1129,1130,1131,1132,1133,1134,1135,1136,1137,1138,1139,1140,1141,1142,1143,1144,1145,1146,1147,1148,1149,1150,1151},
		{1152,1153,1154,1155,1156,1157,1158,1159,1160,1161,1162,1163,1164,1165,1166,1167,1168,1169,1170,1171,1172,1173,1174,1175,1176,1177,1178,1179,1180,1181,1182,1183,1184,1185,1186,1187,1188,1189,1190,1191,1192,1193,1194,1195,1196,1197,1198,1199,1200,1201,1202,1203,1204,1205,1206,1207,1208,1209,1210,1211,1212,1213,1214,1215},
		{1216,1217,1218,1219,1220,1221,1222,1223,1224,1225,1226,1227,1228,1229,1230,1231,1232,1233,1234,1235,1236,1237,1238,1239,1240,1241,1242,1243,1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255,1256,1257,1258,1259,1260,1261,1262,1263,1264,1265,1266,1267,1268,1269,1270,1271,1272,1273,1274,1275,1276,1277,1278,1279},
		{1280,1281,1282,1283,1284,1285,1286,1287,1288,1289,1290,1291,1292,1293,1294,1295,1296,1297,1298,1299,1300,1301,1302,1303,1304,1305,1306,1307,1308,1309,1310,1311,1312,1313,1314,1315,1316,1317,1318,1319,1320,1321,1322,1323,1324,1325,1326,1327,1328,1329,1330,1331,1332,1333,1334,1335,1336,1337,1338,1339,1340,1341,1342,1343},
		{1344,1345,1346,1347,1348,1349,1350,1351,1352,1353,1354,1355,1356,1357,1358,1359,1360,1361,1362,1363,1364,1365,1366,1367,1368,1369,1370,1371,1372,1373,1374,1375,1376,1377,1378,1379,1380,1381,1382,1383,1384,1385,1386,1387,1388,1389,1390,1391,1392,1393,1394,1395,1396,1397,1398,1399,1400,1401,1402,1403,1404,1405,1406,1407},
		{1408,1409,1410,1411,1412,1413,1414,1415,1416,1417,1418,1419,1420,1421,1422,1423,1424,1425,1426,1427,1428,1429,1430,1431,1432,1433,1434,1435,1436,1437,1438,1439,1440,1441,1442,1443,1444,1445,1446,1447,1448,1449,1450,1451,1452,1453,1454,1455,1456,1457,1458,1459,1460,1461,1462,1463,1464,1465,1466,1467,1468,1469,1470,1471},
		{1472,1473,1474,1475,1476,1477,1478,1479,1480,1481,1482,1483,1484,1485,1486,1487,1488,1489,1490,1491,1492,1493,1494,1495,1496,1497,1498,1499,1500,1501,1502,1503,1504,1505,1506,1507,1508,1509,1510,1511,1512,1513,1514,1515,1516,1517,1518,1519,1520,1521,1522,1523,1524,1525,1526,1527,1528,1529,1530,1531,1532,1533,1534,1535}		
	};
	static final int[][] LINES = {
		{-1,  0,64,128,192,256,320,384,448,512,576,640,704,768,832,896,960,1024,1088,1152,1216,1280,1344,1408,1472},
		{-1,  1,65,129,193,257,321,385,449,513,577,641,705,769,833,897,961,1025,1089,1153,1217,1281,1345,1409,1473},
		{-1,  2,66,130,194,258,322,386,450,514,578,642,706,770,834,898,962,1026,1090,1154,1218,1282,1346,1410,1474},
		{-1,  3,67,131,195,259,323,387,451,515,579,643,707,771,835,899,963,1027,1091,1155,1219,1283,1347,1411,1475},
		{-1,  4,68,132,196,260,324,388,452,516,580,644,708,772,836,900,964,1028,1092,1156,1220,1284,1348,1412,1476},
		{-1,  5,69,133,197,261,325,389,453,517,581,645,709,773,837,901,965,1029,1093,1157,1221,1285,1349,1413,1477},
		{-1,  6,70,134,198,262,326,390,454,518,582,646,710,774,838,902,966,1030,1094,1158,1222,1286,1350,1414,1478},
		{-1,  7,71,135,199,263,327,391,455,519,583,647,711,775,839,903,967,1031,1095,1159,1223,1287,1351,1415,1479},
		{-1,  8,72,136,200,264,328,392,456,520,584,648,712,776,840,904,968,1032,1096,1160,1224,1288,1352,1416,1480},
		{-1,  9,73,137,201,265,329,393,457,521,585,649,713,777,841,905,969,1033,1097,1161,1225,1289,1353,1417,1481},
		{-1,  10,74,138,202,266,330,394,458,522,586,650,714,778,842,906,970,1034,1098,1162,1226,1290,1354,1418,1482},
		{-1,  11,75,139,203,267,331,395,459,523,587,651,715,779,843,907,971,1035,1099,1163,1227,1291,1355,1419,1483},
		{-1,  12,76,140,204,268,332,396,460,524,588,652,716,780,844,908,972,1036,1100,1164,1228,1292,1356,1420,1484},
		{-1,  13,77,141,205,269,333,397,461,525,589,653,717,781,845,909,973,1037,1101,1165,1229,1293,1357,1421,1485},
		{-1,  14,78,142,206,270,334,398,462,526,590,654,718,782,846,910,974,1038,1102,1166,1230,1294,1358,1422,1486},
		{-1,  15,79,143,207,271,335,399,463,527,591,655,719,783,847,911,975,1039,1103,1167,1231,1295,1359,1423,1487},
		{-1,  16,80,144,208,272,336,400,464,528,592,656,720,784,848,912,976,1040,1104,1168,1232,1296,1360,1424,1488},
		{-1,  17,81,145,209,273,337,401,465,529,593,657,721,785,849,913,977,1041,1105,1169,1233,1297,1361,1425,1489},
		{-1,  18,82,146,210,274,338,402,466,530,594,658,722,786,850,914,978,1042,1106,1170,1234,1298,1362,1426,1490},
		{-1,  19,83,147,211,275,339,403,467,531,595,659,723,787,851,915,979,1043,1107,1171,1235,1299,1363,1427,1491},
		{-1,  20,84,148,212,276,340,404,468,532,596,660,724,788,852,916,980,1044,1108,1172,1236,1300,1364,1428,1492},
		{-1,  21,85,149,213,277,341,405,469,533,597,661,725,789,853,917,981,1045,1109,1173,1237,1301,1365,1429,1493},
		{-1,  22,86,150,214,278,342,406,470,534,598,662,726,790,854,918,982,1046,1110,1174,1238,1302,1366,1430,1494},
		{-1,  23,87,151,215,279,343,407,471,535,599,663,727,791,855,919,983,1047,1111,1175,1239,1303,1367,1431,1495},
		{-1,  24,88,152,216,280,344,408,472,536,600,664,728,792,856,920,984,1048,1112,1176,1240,1304,1368,1432,1496},
		{-1,  25,89,153,217,281,345,409,473,537,601,665,729,793,857,921,985,1049,1113,1177,1241,1305,1369,1433,1497},
		{-1,  26,90,154,218,282,346,410,474,538,602,666,730,794,858,922,986,1050,1114,1178,1242,1306,1370,1434,1498},
		{-1,  27,91,155,219,283,347,411,475,539,603,667,731,795,859,923,987,1051,1115,1179,1243,1307,1371,1435,1499},
		{-1,  28,92,156,220,284,348,412,476,540,604,668,732,796,860,924,988,1052,1116,1180,1244,1308,1372,1436,1500},
		{-1,  29,93,157,221,285,349,413,477,541,605,669,733,797,861,925,989,1053,1117,1181,1245,1309,1373,1437,1501},
		{-1,  30,94,158,222,286,350,414,478,542,606,670,734,798,862,926,990,1054,1118,1182,1246,1310,1374,1438,1502},
		{-1,  31,95,159,223,287,351,415,479,543,607,671,735,799,863,927,991,1055,1119,1183,1247,1311,1375,1439,1503},
		{-1,  32,96,160,224,288,352,416,480,544,608,672,736,800,864,928,992,1056,1120,1184,1248,1312,1376,1440,1504},
		{-1,  33,97,161,225,289,353,417,481,545,609,673,737,801,865,929,993,1057,1121,1185,1249,1313,1377,1441,1505},
		{-1,  34,98,162,226,290,354,418,482,546,610,674,738,802,866,930,994,1058,1122,1186,1250,1314,1378,1442,1506},
		{-1,  35,99,163,227,291,355,419,483,547,611,675,739,803,867,931,995,1059,1123,1187,1251,1315,1379,1443,1507},
		{-1,  36,100,164,228,292,356,420,484,548,612,676,740,804,868,932,996,1060,1124,1188,1252,1316,1380,1444,1508},
		{-1,  37,101,165,229,293,357,421,485,549,613,677,741,805,869,933,997,1061,1125,1189,1253,1317,1381,1445,1509},
		{-1,  38,102,166,230,294,358,422,486,550,614,678,742,806,870,934,998,1062,1126,1190,1254,1318,1382,1446,1510},
		{-1,  39,103,167,231,295,359,423,487,551,615,679,743,807,871,935,999,1063,1127,1191,1255,1319,1383,1447,1511},
		{-1,  40,104,168,232,296,360,424,488,552,616,680,744,808,872,936,1000,1064,1128,1192,1256,1320,1384,1448,1512},
		{-1,  41,105,169,233,297,361,425,489,553,617,681,745,809,873,937,1001,1065,1129,1193,1257,1321,1385,1449,1513},
		{-1,  42,106,170,234,298,362,426,490,554,618,682,746,810,874,938,1002,1066,1130,1194,1258,1322,1386,1450,1514},
		{-1,  43,107,171,235,299,363,427,491,555,619,683,747,811,875,939,1003,1067,1131,1195,1259,1323,1387,1451,1515},
		{-1,  44,108,172,236,300,364,428,492,556,620,684,748,812,876,940,1004,1068,1132,1196,1260,1324,1388,1452,1516},
		{-1,  45,109,173,237,301,365,429,493,557,621,685,749,813,877,941,1005,1069,1133,1197,1261,1325,1389,1453,1517},
		{-1,  46,110,174,238,302,366,430,494,558,622,686,750,814,878,942,1006,1070,1134,1198,1262,1326,1390,1454,1518},
		{-1,  47,111,175,239,303,367,431,495,559,623,687,751,815,879,943,1007,1071,1135,1199,1263,1327,1391,1455,1519},
		{-1,  48,112,176,240,304,368,432,496,560,624,688,752,816,880,944,1008,1072,1136,1200,1264,1328,1392,1456,1520},
		{-1,  49,113,177,241,305,369,433,497,561,625,689,753,817,881,945,1009,1073,1137,1201,1265,1329,1393,1457,1521},
		{-1,  50,114,178,242,306,370,434,498,562,626,690,754,818,882,946,1010,1074,1138,1202,1266,1330,1394,1458,1522},
		{-1,  51,115,179,243,307,371,435,499,563,627,691,755,819,883,947,1011,1075,1139,1203,1267,1331,1395,1459,1523},
		{-1,  52,116,180,244,308,372,436,500,564,628,692,756,820,884,948,1012,1076,1140,1204,1268,1332,1396,1460,1524},
		{-1,  53,117,181,245,309,373,437,501,565,629,693,757,821,885,949,1013,1077,1141,1205,1269,1333,1397,1461,1525},
		{-1,  54,118,182,246,310,374,438,502,566,630,694,758,822,886,950,1014,1078,1142,1206,1270,1334,1398,1462,1526},
		{-1,  55,119,183,247,311,375,439,503,567,631,695,759,823,887,951,1015,1079,1143,1207,1271,1335,1399,1463,1527},
		{-1,  56,120,184,248,312,376,440,504,568,632,696,760,824,888,952,1016,1080,1144,1208,1272,1336,1400,1464,1528},
		{-1,  57,121,185,249,313,377,441,505,569,633,697,761,825,889,953,1017,1081,1145,1209,1273,1337,1401,1465,1529},
		{-1,  58,122,186,250,314,378,442,506,570,634,698,762,826,890,954,1018,1082,1146,1210,1274,1338,1402,1466,1530},
		{-1,  59,123,187,251,315,379,443,507,571,635,699,763,827,891,955,1019,1083,1147,1211,1275,1339,1403,1467,1531},
		{-1,  60,124,188,252,316,380,444,508,572,636,700,764,828,892,956,1020,1084,1148,1212,1276,1340,1404,1468,1532},
		{-1,  61,125,189,253,317,381,445,509,573,637,701,765,829,893,957,1021,1085,1149,1213,1277,1341,1405,1469,1533},
		{-1,  62,126,190,254,318,382,446,510,574,638,702,766,830,894,958,1022,1086,1150,1214,1278,1342,1406,1470,1534},
		{-1,  63,127,191,255,319,383,447,511,575,639,703,767,831,895,959,1023,1087,1151,1215,1279,1343,1407,1471,1535}
	};
	
	public void setSideBrimPixel(int x, int y, int color) {
		while(x<0) x=x+64;
		while(x>=64) x=x-64;
		while(y<0) y=y+24;
		while(y>=24) y=y-24;
		sideBrim[y*64+x] = color;
	}
	public int getSidePrimPixel(int x, int y) {
		while(x<0) x=x+64;
		while(x>=64) x=x-64;
		while(y<0) y=y+24;
		while(y>=24) y=y-24;
		return sideBrim[y*64+x];
	}
	
	public void setPixel(int p, int color) {
		if(p<54) topEdges[p] = color;
		else if(p<295) topRing[p-54] = color;
		else sideBrim[p-295] = color;
	}
	public int getPixel(int p) {
		if(p<54) return topEdges[p];
		else if(p<295) return topRing[p-54];
		else return sideBrim[p-295];
	}
	
	public void setLine(int n, int color) {
		int [] pix = LINES[n];
		for(int p : pix) {
			setPixel(p+295,color);
		}		
	}
	public void setRing(int n, int color) {
		int [] pix = RINGS[n];
		for(int p : pix) {
			setPixel(p+295,color);
		}	
	}
	public void drawSprite(int x, int y, int [][] sprite) {
		for(int yy=0;yy<sprite.length;++yy) {
			for(int xx=0;xx<sprite[y].length;++xx) {
				setSideBrimPixel(x+xx,y+yy,sprite[yy][xx]);
			}
		}		
	}
	
	private String dataRun(int [] data, int pos,int count) {
		String ret = "";
		for(int x=pos;x<pos+count;++x) {
			String v = Integer.toString(data[x],16).toUpperCase();
			if(v.length()==1) v="0"+v;
			if(v.equals("00")) v = "..";
			ret = ret + v +" ";
		}		
		return ret;
	}
	
	public String toString() {
		// Edges
		String ret = "----------------------------------------------------------\n";
		ret = ret + dataRun(topEdges,0,27);
		ret = ret + "; 27\n";
		ret = ret + dataRun(topEdges,27,27);
		ret = ret + "; 27\n";
		ret = ret + "----------------------------------------------------------\n";
		// Ring
		int i = 0;
		ret = ret + dataRun(topRing,i,1)+"; 1\n";
		i = i + 1;
		ret = ret + dataRun(topRing,i,8)+"; 8\n";
		i = i + 8;		
		ret = ret + dataRun(topRing,i,12)+"; 12\n";
		i = i + 12;
		ret = ret + dataRun(topRing,i,16)+"; 16\n";
		i = i + 16;
		ret = ret + dataRun(topRing,i,24)+"; 24\n";
		i = i + 24;
		ret = ret + dataRun(topRing,i,32)+"; 32\n";
		i = i + 32;
		ret = ret + dataRun(topRing,i,40)+"; 40\n";
		i = i + 40;
		ret = ret + dataRun(topRing,i,48)+"; 48\n";
		i = i + 48;
		ret = ret + dataRun(topRing,i,60)+"; 60\n";
		i = i + 60;
		ret = ret + "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
		// SideBrim
		for(int y=0;y<24;++y) {
			String v = dataRun(sideBrim,y*64,64);
			v = v.substring(0,96)+"| "+v.substring(96);
			if(y==8 || y==16) {
				ret = ret + "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
			}
			ret = ret + v + "\n";			
		}
		ret = ret + "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------\n";
		
		return ret;
	}
	
	private int [] runFromString(String s, int binOffset, int count) {
		int [] ret = new int[count];
		binOffset = binOffset * 2;
		for(int x=0;x<count;++x) {
			ret[x] = Integer.parseInt(s.substring(binOffset+x*2, binOffset+x*2+2),16);
		}
		return ret;		
	}
	
	public void fromString(String s) {
		String lines[] = s.split("\\r?\\n");
		String raw = "";
		for(int x=0;x<lines.length;++x) {
			String t = lines[x];
			int i = t.indexOf(";");
			if(i>=0) {
				lines[x] = t.substring(0,i);
			}
		}
		for(String r : lines) {
			raw = raw + r;
		}
		raw = raw.replaceAll("-", "");
		raw = raw.replaceAll("\\|", "");
		raw = raw.replaceAll(" ", "");
		raw = raw.replaceAll("\\.\\.", "00");		
		
		if(raw.length()!=1831*2) {
			throw new RuntimeException("Invalid frame text representation");
		}
		
		topEdges = runFromString(raw,0,54);
		topRing = runFromString(raw,54,241);
		sideBrim = runFromString(raw,295,256*6);		
	}
	
	private List<Integer> getRectangle(int x, int y) {
		List<Integer> ret = new ArrayList<>();
		for(int xx=31;xx>=0;--xx) {
			for(int yy=7;yy>=0;--yy) {
				ret.add(sideBrim[(yy+y)*64+(xx+x)]);
			}
			--xx;
			for(int yy=0;yy<8;++yy) {
				ret.add(sideBrim[(yy+y)*64+(xx+x)]);
			}
		}
		return ret;
	}
	
	public int[] getBinary(boolean cpuA) {
		List<Integer> data = new ArrayList<Integer>();		
		
		if(cpuA) {
			// This is the giant swap
			// A1 256 grid upper left
			data.addAll(getRectangle(0,0));		
			// A2 256 grid upper right
			data.addAll(getRectangle(32,0));
			// A3 256 grid lower left
			data.addAll(getRectangle(0,8));
			// A4 256 grid lower right
			data.addAll(getRectangle(32,8));
		} else {
		
			// The brim may be different
			
			// B1 256 left brim
			data.addAll(getRectangle(0,16));
			// B2 256 right brim
			data.addAll(getRectangle(32,16));
			
			// B3  54 top edges
			//  202 00s
			for(int d : topEdges) {
				data.add(d);
			}
			for(int x=0;x<202;++x) data.add(0);		
			// B4 241 top ring
			//   15 00s
			for(int d : topRing) {
				data.add(d);
			}
			for(int x=0;x<15;++x) data.add(0);				
			
		}
		
		int [] ret = new int[1024];
		for(int x=0;x<1024;++x) ret[x] = data.get(x);
		return ret;
	}		
	
	/*
	public static void generateSpin(int [] data) {
		int pos = 0;
		
	}
	
	public static void main(String [] args) throws Exception {
		// TEST
		HatFrame f = new HatFrame();
		f.setPixel(0, 0x55);
		f.setLine(5, 8);
		f.setRing(12, 9);
		
		
		
		String s = f.toString();
		System.out.println(f.toString());
		f.fromString(s);
		System.out.println(f.toString());
		int [] d = f.getBinary(true);		
		
	}
	*/

}
