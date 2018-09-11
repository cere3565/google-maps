<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Eren_web.aspx.vb" Inherits="Eren_10508.Eren_web" %>

<!DOCTYPE html>


<html>
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>二仁溪流域監控</title>
    
    <style type="text/css"></style>
    <script type="text/javascript" src = "https://maps.googleapis.com/maps/api/js?key=AIzaSyA1WszqgapT7YepULFa8B-ne2chvxzWv98&sensor=false"></script>
    
    <script type="text/javascript" src="Scripts/convexhull.js" ></script>
    <script type="text/javascript" src="Scripts/clipper.js"></script>
    <script type="text/javascript" src="Scripts/javascript.util.js"></script>
    <script type="text/javascript" src="Scripts/jsts.js"></script>
    <script type="text/javascript" src="Scripts/wicket.js"></script>
    <script type="text/javascript" src="Scripts/wicket-gmap3.js"></script>
    <script type="text/javascript">
       
        var markers = [];
        var markers1 = [];
        var markers2 = [];
        var Udis;
        var Ddis;
        var U1 = []; var U2 = []; var U3 = []; var U4 = []; var U5 = [];
        var UmyTrip1 = []; var UmyTrip2 = []; var UmyTrip3 = []; var UmyTrip4 = []; var UmyTrip5 = [];
        var D1 = []; var D2 = []; var D3 = []; var D4 = []; var D5 = [];
        var DmyTrip1 = []; var DmyTrip2 = []; var DmyTrip3 = []; var DmyTrip4 = []; var DmyTrip5 = [];
        var hull;
        var infoWindow;
        var map;
        var lineCentersU = [];
        var lineCentersD = [];

        function initialize() {
            markers = JSON.parse('<%=ConvertDataTabletoString()%>');

            //地圖設定
            var CenterPoint = new google.maps.LatLng(22.95670181363295, 120.26498818242747);
            var mapOptions = {
                center: CenterPoint,                       //顯示時的地圖中心點
                zoom: 12,                                  //地圖縮放倍率
                mapTypeId: google.maps.MapTypeId.ROADMAP   //地圖類型
            };

            infoWindow = new google.maps.InfoWindow();
            map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);

            //在地圖上標示資料庫所有的資料點
            for (i = 0; i < markers.length; i++) {

                //if (markers[i].pp=="1") {
                //    markers2.push({x: markers[i].lat, y: markers[i].lng })                   
                //}
                //else {
                //    markers1.push({ x: markers[i].lat, y: markers[i].lng })
                //}
                if (i < markers.length / 2) {
                    markers1.push({ x: markers[i].lat, y: markers[i].lng })
                }
                else {
                    markers2.push({ x: markers[i].lat, y: markers[i].lng })
                }

                var data = markers[i]
                var myLatlng = new google.maps.LatLng(data.lat, data.lng);   //標示資料庫所有的資料點
                var marker = new google.maps.Marker({
                    position: myLatlng,
                    icon: 'Images/pink.png',
                    map: map,
                    title: data.title
                });
            }


            //上面路徑
            var lineU;
            function iniU() {
                lineCentersU = [
                  new google.maps.LatLng(22.971783, 120.249191),
                  new google.maps.LatLng(22.969694, 120.248883),
                  new google.maps.LatLng(22.969694, 120.248883),
                  new google.maps.LatLng(22.963219, 120.246139),
                  new google.maps.LatLng(22.960835, 120.246958),
                  new google.maps.LatLng(22.960442, 120.246714),
                  new google.maps.LatLng(22.960067, 120.245931),
                  new google.maps.LatLng(22.959331, 120.245311),
                  new google.maps.LatLng(22.958138, 120.244748),
                  new google.maps.LatLng(22.957504, 120.244663),
                  new google.maps.LatLng(22.956758, 120.244470),
                  new google.maps.LatLng(22.956200, 120.243346),
                  new google.maps.LatLng(22.956148, 120.242560),
                  new google.maps.LatLng(22.955970, 120.241890),
                  new google.maps.LatLng(22.955610, 120.240895),
                  new google.maps.LatLng(22.955970, 120.241890),
                  new google.maps.LatLng(22.955610, 120.240895),
                  new google.maps.LatLng(22.954965, 120.240581),
                  new google.maps.LatLng(22.954451, 120.240707),
                  new google.maps.LatLng(22.953108, 120.240921),
                  new google.maps.LatLng(22.952293, 120.241206),
                  new google.maps.LatLng(22.949919, 120.241093),
                  new google.maps.LatLng(22.949023, 120.240680),
                  new google.maps.LatLng(22.946118, 120.241466),
                  new google.maps.LatLng(22.943413, 120.239945),
                  new google.maps.LatLng(22.942717, 120.239124),
                  new google.maps.LatLng(22.939903, 120.236431),
                  new google.maps.LatLng(22.940100, 120.233256),
                  new google.maps.LatLng(22.928204, 120.225230),
                  new google.maps.LatLng(22.929073, 120.223471),
                  new google.maps.LatLng(22.926544, 120.218021),
                  new google.maps.LatLng(22.930773, 120.217119),
                  new google.maps.LatLng(22.933460, 120.209652),
                  new google.maps.LatLng(22.929350, 120.203215),
                  new google.maps.LatLng(22.928085, 120.193773),
                  new google.maps.LatLng(22.920417, 120.190598),
                  new google.maps.LatLng(22.920764, 120.188703),
                  new google.maps.LatLng(22.913610, 120.176644)];

                //紅色點的設定(UP)
                var lineSymbol = {
                    path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                    scale: 5,
                    strokeColor: '#007500'                //會跑點的顏色
                };
                //紅色點的路徑設定
                lineU = new google.maps.Polyline({
                    path: lineCentersU,
                    strokeColor: '#FFFFFF',               //路徑顏色
                    strokeOpacity: 0.8,
                    icons: [{
                        icon: lineSymbol,
                        offset: '100%'
                    }],
                    map: map
                });
            }
            iniU();

            function animateCircle() {
                var count = 0;
                offsetId = window.setInterval(function () {
                    count = (count + 10) % 201;
                    var icons = lineU.get('icons');
                    icons[0].offset = (count / 2) + '%';
                    lineU.set('icons', icons);
                }, 1000);
            }
            animateCircle();

            //下面路徑
            var lineD;
            function iniD() {
                lineCentersD = [
                       new google.maps.LatLng(22.946243, 120.307770),
                       new google.maps.LatLng(22.946332, 120.307233),
                       new google.maps.LatLng(22.946841, 120.305615),
                       new google.maps.LatLng(22.945483, 120.304722),
                       new google.maps.LatLng(22.945161, 120.304110),
                       new google.maps.LatLng(22.944282, 120.303939),
                       new google.maps.LatLng(22.944579, 120.303263),
                       new google.maps.LatLng(22.945532, 120.303080),
                       new google.maps.LatLng(22.945403, 120.302088),
                       new google.maps.LatLng(22.943714, 120.302316),
                       new google.maps.LatLng(22.943704, 120.300513),
                       new google.maps.LatLng(22.942152, 120.295079),
                       new google.maps.LatLng(22.940789, 120.291024),
                       new google.maps.LatLng(22.939564, 120.291346),
                       new google.maps.LatLng(22.940947, 120.289694),
                       new google.maps.LatLng(22.932532, 120.273688),
                       new google.maps.LatLng(22.939824, 120.268807),
                       new google.maps.LatLng(22.926266, 120.255748),
                       new google.maps.LatLng(22.921186, 120.258342),
                       new google.maps.LatLng(22.919827, 120.257376),
                       new google.maps.LatLng(22.919550, 120.255316),
                       new google.maps.LatLng(22.918088, 120.251239),
                       new google.maps.LatLng(22.919372, 120.251261),
                       new google.maps.LatLng(22.918523, 120.248900),
                       new google.maps.LatLng(22.916146, 120.244802),
                       new google.maps.LatLng(22.918399, 120.245767),
                       new google.maps.LatLng(22.917668, 120.241218),
                       new google.maps.LatLng(22.918913, 120.237828),
                       new google.maps.LatLng(22.917767, 120.236519),
                       new google.maps.LatLng(22.919150, 120.232399),
                       new google.maps.LatLng(22.918992, 120.230361),
                       new google.maps.LatLng(22.916838, 120.229782),
                       new google.maps.LatLng(22.916680, 120.229503),
                       new google.maps.LatLng(22.910922, 120.221506),
                       new google.maps.LatLng(22.917751, 120.204410),
                       new google.maps.LatLng(22.918709, 120.195312),
                       new google.maps.LatLng(22.920764, 120.188703),
                       new google.maps.LatLng(22.913610, 120.176644)];

                //藍色點的設定(DOWN)
                var lineSymbolD = {
                    path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
                    scale: 5,
                    strokeColor: '#0000CC'                //會跑點的顏色
                };
                //藍色點的路徑設定
                lineD = new google.maps.Polyline({
                    path: lineCentersD,
                    strokeColor: '#FFFFFF',               //路徑顏色
                    strokeOpacity: 0.8,
                    icons: [{
                        icon: lineSymbolD,
                        offset: '100%'
                    }],
                    map: map
                });
            }
            iniD();

            function animateCircleD() {
                var count = 0;
                offsetId = window.setInterval(function () {
                    count = (count + 10) % 201;
                    var icons = lineD.get('icons');
                    icons[0].offset = (count / 2) + '%';
                    lineD.set('icons', icons);
                }, 1000);
            }
            animateCircleD();
        }

        var k;
        var gj;
       var flightPath1;
       var flightPath2;
       var flightPath3;
       var flightPath4;
       var flightPath5;
       var myvar;
       var flightPathA;
       var flightPathB;
       var flightPathC;
       var flightPathD;
       var flightPathE;
       var newPoly;

       var polyDrawed=[];

       function myPolygon() {
           k = -1;
           gj = -1;
           myvar = setInterval(polygonDelay, 1500);
       }

       function StopTimer() {
           clearInterval(myvar);
       }

       function polygonDelay() {
          
           k++;
           if (k >= lineCentersU.length) { k = -1; }

           gj++;
           if (gj >= lineCentersD.length) { gj = -1; }

           var canvas = document.getElementById("map_canvas");
           hull = new ConvexHull();

           
           if (flightPath1 != undefined) {
               flightPath1.setMap(null);
               flightPath1.length = 0;
           }
           if (flightPathA != undefined) {
               flightPathA.setMap(null);
               flightPathA.length = 0;
           }

           if (flightPath2 != undefined) {
               flightPath2.setMap(null);
               flightPath2.length = 0;
           }
           if (flightPathB != undefined) {
               flightPathB.setMap(null);
               flightPathB.length = 0;
           }

           if (flightPath3 != undefined) {
               flightPath3.setMap(null);
               flightPath3.length = 0;
           }
           if (flightPathC != undefined) {
               flightPathC.setMap(null);
               flightPathC.length = 0;
           }

           if (flightPath4 != undefined) {
               flightPath4.setMap(null);
               flightPath4.length = 0;
           }
           if (flightPathD != undefined) {
               flightPathD.setMap(null);
               flightPathD.length = 0;
           }
           if (flightPath5 != undefined) {
               flightPath5.setMap(null);
               flightPath5.length = 0;
           }
           if (flightPathE != undefined) {
               flightPathE.setMap(null);
               flightPathE.length = 0;
           }
           while (polyDrawed[0]) {
               polyDrawed.pop().setMap(null);
               console.log("map null");
           }
          
           console.log("k= ", k);
           console.log(lineCentersU[k].lat());
           console.log("gj= ", gj);
           console.log(lineCentersD[gj].lat());

           U1.length = 0;          
           U2.length = 0;           
           U3.length = 0;           
           U4.length = 0;           
           U5.length = 0;
           
           D1.length = 0;
           D2.length = 0;
           D3.length = 0;
           D4.length = 0;
           D5.length = 0;

           UmyTrip1.length = 0;
           UmyTrip2.length = 0;
           UmyTrip3.length = 0;
           UmyTrip4.length = 0;
           UmyTrip5.length = 0;

           DmyTrip1.length = 0;
           DmyTrip2.length = 0;
           DmyTrip3.length = 0;
           DmyTrip4.length = 0;
           DmyTrip5.length = 0;

           

           for (var i = 0; i < markers1.length; i++) {
               Udis = Math.sqrt((Math.pow((parseFloat(lineCentersU[k].lat()) - parseFloat(markers1[i].x)), 2) + Math.pow((parseFloat(lineCentersU[k].lng()) - parseFloat(markers1[i].y)), 2)))
              
               if (Udis <= 3 * 0.01) {
                   U1.push({ x: markers1[i].x, y: markers1[i].y })
               }
               if (Udis <= 3 * 0.02) {
                   U2.push({ x: markers1[i].x, y: markers1[i].y })
               }
               if (Udis <= 3 * 0.03) {
                   U3.push({ x: markers1[i].x, y: markers1[i].y })
               }
               if (Udis <= 3 * 0.04) {
                   U4.push({ x: markers1[i].x, y: markers1[i].y })
               }
               if (Udis <= 3 * 0.05) {
                   U5.push({ x: markers1[i].x, y: markers1[i].y })
               }
           }

          for(var v = 0; v < markers2.length; v++) {
               Ddis = Math.sqrt((Math.pow((parseFloat(lineCentersD[gj].lat()) - parseFloat(markers2[v].x)), 2) + Math.pow((parseFloat(lineCentersD[gj].lng()) - parseFloat(markers2[v].y)), 2)))

               if (Ddis <= 3 * 0.01) {
                   D1.push({ x: markers2[v].x, y: markers2[v].y })
               }
               if (Ddis <= 3 * 0.02) {
                   D2.push({ x: markers2[v].x, y: markers2[v].y })
               }
               if (Ddis <= 3 * 0.03) {
                   D3.push({ x: markers2[v].x, y: markers2[v].y })
               }
               if (Ddis <= 3 * 0.04) {
                   D4.push({ x: markers2[v].x, y: markers2[v].y })
               }
               if (Ddis <= 3 * 0.05) {
                   D5.push({ x: markers2[v].x, y: markers2[v].y })
               }
           }

          
           //將U1()所取得座標經由JS1計算外圍以及依順序排列
           hull.compute(U1);
           var indices = hull.getIndices();
          
           if (indices != null ) {
               for (var i = 0; i < indices.length; i++) {
                   var t1 = new google.maps.LatLng(U1[indices[i]].x, U1[indices[i]].y);
                   UmyTrip1.push(t1);
               }
           }
         
           hull.compute(D1);
           var indices = hull.getIndices();
           if (indices != null) {
               for (var i = 0; i < indices.length; i++) {
                   var Q1 = new google.maps.LatLng(D1[indices[i]].x, D1[indices[i]].y);
                   DmyTrip1.push(Q1);
               }
           }
          
           //將U2()所取得座標經由JS1計算外圍以及依順序排列
          hull.compute(U2);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var t2 = new google.maps.LatLng(U2[indices[i]].x, U2[indices[i]].y);
                   UmyTrip2.push(t2);
               }
           }
           hull.compute(D2);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var Q2 = new google.maps.LatLng(D2[indices[i]].x, D2[indices[i]].y);
                   DmyTrip2.push(Q2);
               }
           }

           //將U3()所取得座標經由JS1計算外圍以及依順序排列
          hull.compute(U3);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var t3 = new google.maps.LatLng(U3[indices[i]].x, U3[indices[i]].y);
                   UmyTrip3.push(t3);
               }
           }
           hull.compute(D3);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var Q3 = new google.maps.LatLng(D3[indices[i]].x, D3[indices[i]].y);
                   DmyTrip3.push(Q3);
               }
           }

           //將U4()所取得座標經由JS1計算外圍以及依順序排列
           hull.compute(U4);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var t4 = new google.maps.LatLng(U4[indices[i]].x, U4[indices[i]].y);
                   UmyTrip4.push(t4);
               }
           }
           hull.compute(D4);
           indices = hull.getIndices();
           if (indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var Q4 = new google.maps.LatLng(D4[indices[i]].x, D4[indices[i]].y);
                   DmyTrip4.push(Q4);
               }
           }

           //將U5()所取得座標經由JS1計算外圍以及依順序排列
           hull.compute(U5);
           indices = hull.getIndices();
           if (indices && indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var t5 = new google.maps.LatLng(U5[indices[i]].x, U5[indices[i]].y);
                   UmyTrip5.push(t5);
               }
           }
           hull.compute(D5);
           indices = hull.getIndices();
           if (indices && indices.length > 0) {
               for (var i = 0; i < indices.length; i++) {
                   var Q5 = new google.maps.LatLng(D5[indices[i]].x, D5[indices[i]].y);
                   DmyTrip5.push(Q5);
               }
           }

           //畫出指定陣列"myTrip"的所有座標點
           //myTrip1

           flightPath1 = new google.maps.Polygon({
               path: UmyTrip1,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#FFFF77",
               fillOpacity: 0.2
           });
           

 
           flightPathA = new google.maps.Polygon({
               path: DmyTrip1,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#77DDFF",
               fillOpacity: 0.2
           });
           


           //myTrip2
     
           flightPath2 = new google.maps.Polygon({
               path: UmyTrip2,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#FFFF77",
               fillOpacity: 0.2
           });


           flightPathB = new google.maps.Polygon({
               path: DmyTrip2,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#77DDFF",
               fillOpacity: 0.2
           });

           flightPath3 = new google.maps.Polygon({
               path: UmyTrip3,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#FFFF77",
               fillOpacity: 0.2
           });
           
    
           flightPathC = new google.maps.Polygon({
               path: DmyTrip3,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#77DDFF",
               fillOpacity: 0.2
           });
           
         
           //myTrip4
           flightPath4 = new google.maps.Polygon({
               path: UmyTrip4,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#FFFF77",
               fillOpacity: 0.2
           });
          
         
           flightPathD = new google.maps.Polygon({
               path: DmyTrip4,
               strokeColor: "#000000",
               strokeOpacity: 1,
               strokeWeight: 1,
               fillColor: "#77DDFF",
               fillOpacity: 0.2
           });
         
           flightPath5 = new google.maps.Polygon
               ({
                   path: UmyTrip5,
                   strokeColor: "#000000",
                   strokeOpacity: 1,
                   strokeWeight: 1,
                   fillColor: "#FFFF77",
                   fillOpacity: 0.2
               });
         
           flightPathE = new google.maps.Polygon
               ({
                   path: DmyTrip5,
                   strokeColor: "#000000",
                   strokeOpacity: 1,
                   strokeWeight: 1,
                   fillColor: "#77DDFF",
                   fillOpacity: 0.2
               });


           flightPath5.setMap(map);
           polyDrawed.push(flightPath4);
           flightPath4.setMap(map);
           polyDrawed.push(flightPath4);
           flightPath3.setMap(map);
           polyDrawed.push(flightPath3);
           flightPath2.setMap(map);
           polyDrawed.push(flightPath2);
           flightPath1.setMap(map);
           polyDrawed.push(flightPath1);
           flightPathE.setMap(map);
           polyDrawed.push(flightPath4);
           flightPathD.setMap(map);
           polyDrawed.push(flightPath4);
           flightPathC.setMap(map);
           polyDrawed.push(flightPathC);
           flightPathB.setMap(map);
           polyDrawed.push(flightPathB);
           flightPathA.setMap(map);
           polyDrawed.push(flightPathA);

           if (document.getElementById("myCheck").checked == true) {
               
               DissolveTwoGeometriesWithJSTS(flightPath1, flightPathA, map);
               DissolveTwoGeometriesWithJSTS(flightPath2, flightPathB, map);
               DissolveTwoGeometriesWithJSTS(flightPath3, flightPathC, map);
               DissolveTwoGeometriesWithJSTS(flightPath4, flightPathD, map);
               DissolveTwoGeometriesWithJSTS(flightPath5, flightPathE, map);
           }
           
       }//polygonDelay()
     
       
       //凸多邊形合併
       function DissolveTwoGeometriesWithJSTS(polygon1, polygon2, map) {
           // Instantiate Wicket
           var wicket = new Wkt.Wkt();

           wicket.fromObject(polygon1);  // import a Google Polygon
           var wkt1 = wicket.write();    // read the polygon into a WKT object

           wicket.fromObject(polygon2);  // repeat, creating a second WKT ojbect
           var wkt2 = wicket.write();

           // Instantiate JSTS WKTReader and get two JSTS geometry objects
           var wktReader = new jsts.io.WKTReader();
           var geom1 = wktReader.read(wkt1);
           var geom2 = wktReader.read(wkt2);

           // In JSTS, "union" is synonymous with "dissolve"
           var dissolvedGeometry = geom1.union(geom2);

           // Instantiate JSTS WKTWriter and get new geometry's WKT
           var wktWriter = new jsts.io.WKTWriter();
           var wkt = wktWriter.write(dissolvedGeometry);

           // Reuse your Wicket object to ingest the new geometry's WKT
           wicket.read(wkt);

           // Assemble your new polygon's options, I used object notation
           var polyOptions = {
               strokeColor: '#000000',
               strokeOpacity: 0.8,
               strokeWeight: 2,
               fillColor: '	#8600FF',
               fillOpacity: 0.25
           };

           // Let wicket create a Google Polygon with the options you defined above
           newPoly = wicket.toObject(polyOptions);
           console.log("newpoly.len==== ", newPoly.length);
           //若合併不成功，newPoly.length = 2
           if ( newPoly!= undefined && newPoly.length != 2) {// Now I'll hide the two original polygons and add the new one.
               polygon1.setMap(null);
               polygon2.setMap(null);
               newPoly.setMap(map);
               polyDrawed.push(newPoly);
           }
           //polygon1.setMap(null);
           //polygon2.setMap(null);
           //newPoly.setMap(null);
       }
       

    </script>
    
</head>

     <body onload="javascript:initialize()">
            <form id="form1" runat="server">
                <h1 style="color:blue"><b>
                    <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Names="標楷體" Font-Size="XX-Large" Font-Underline="False" Text="河川汙染模擬-二仁溪"></asp:Label>
                    </b></h1>
                <div id="map_canvas" style="width: 1000px; height: 516px; margin-top: 0px;"></div><br/>
                <input type="button" value="START" onclick="myPolygon()" style="height: 35px; width: 95px">
                <input type="button" value="STOP" onclick="StopTimer()" style="height: 35px; width: 95px">
                是否合併: <input type="checkbox" id="myCheck">
                <br/>
            </form>  
        </body> 

</html>
