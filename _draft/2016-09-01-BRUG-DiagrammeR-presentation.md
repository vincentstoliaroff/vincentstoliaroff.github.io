Presentation Package DiagrammeR
================

############# 

Introduction
============

Motivation
----------

### 1 - pimp up your Rmarkdown output

Flowchart, Network Graph, Dependency graph, UML Diagrams, ER Model...

### 2 - One workflow

Everything happens in R

### 3 - Easy Editing/Control

Literate Programming / Reproducible Research

### 4 - Dynamic Updates

Reporting

Focus: `DiagrammeR`
-------------------

### Package Candidates

-   CRAN Task View: <https://cran.r-project.org/web/views/gR.html>
-   Various Packages: `diagram`, `Rgraphviz` (Bioconductor), `networkD3`...

### Upside

-   Extensive Tutorial: <http://rich-iannone.github.io/DiagrammeR/index.html>
-   Integration with RStudio (thanks to `htmlwidgets` dependency), especially for the DOT Language
-   Several Visualisation Engines with varied Layout

### Walk-through Examples

1.  Data Modeling Schema
2.  A transport Network
3.  R Package Dependencies

Reminder: Graph Definition
--------------------------

### Nodes/Vertices

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-71e80e5bf05fd2432136">{"x":{"diagram":"digraph {\n\n  \"1\" [label = \"1\"] \n  \"2\" [label = \"2\"] \n  \"3\" [label = \"3\"] \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
### Edges

Directed Graph <!--html_preserve-->

<script type="application/json" data-for="htmlwidget-4d5103a45b210f0eec18">{"x":{"diagram":"digraph {\n\ngraph [rankdir = LR]\n\n\n  \"1\" [label = \"1\"] \n  \"2\" [label = \"2\"] \n  \"3\" [label = \"3\"] \n  \"1\"->\"2\" \n  \"2\"->\"3\" \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Undirected Graph <!--html_preserve-->

<script type="application/json" data-for="htmlwidget-49a9c6f9e97a528fd290">{"x":{"diagram":"digraph {\n\ngraph [rankdir = LR]\n\nedge [arrowhead = none]\n\n  \"1\" [label = \"1\"] \n  \"2\" [label = \"2\"] \n  \"3\" [label = \"3\"] \n  \"1\"->\"2\" \n  \"2\"->\"3\" \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
############# 

Becoming a `DiagrammeR` | A glimpse into the Package Design
===========================================================

> 1.  The Objects
> 2.  The Languages
> 3.  Querying Graph
> 4.  Visualising

1 - Objects (1): Nodes & Edges | Data Frame
-------------------------------------------

``` r
NDF <-DiagrammeR::create_nodes(nodes = c("a", "b", "c"), # required
                               type = "lower",color="aqua", shape=c("circle","circle","rectangle"),
                               Value = c(3.5, 2.6, 9.4))

EDF <- DiagrammeR::create_edges(from = c("a", "a"),to = c("b", "c"),color = "green",
                                data = c(2.7, 8.9, 2.6, 0.6))
head(NDF)
```

    ##   nodes  type label color     shape Value
    ## 1     a lower     a  aqua    circle   3.5
    ## 2     b lower     b  aqua    circle   2.6
    ## 3     c lower     c  aqua rectangle   9.4

``` r
head(EDF)
```

    ##   from to rel color data
    ## 1    a  b     green  2.7
    ## 2    a  c     green  8.9

1 - Objects (2): Graph | List
-----------------------------

``` r
GRAPH<-DiagrammeR::create_graph(NDF,EDF)
str(GRAPH,max.level=1)
```

    ## List of 10
    ##  $ graph_name : NULL
    ##  $ graph_time : NULL
    ##  $ graph_tz   : NULL
    ##  $ nodes_df   :'data.frame': 3 obs. of  6 variables:
    ##  $ edges_df   :'data.frame': 2 obs. of  5 variables:
    ##  $ graph_attrs: NULL
    ##  $ node_attrs : NULL
    ##  $ edge_attrs : NULL
    ##  $ directed   : logi TRUE
    ##  $ dot_code   : chr "digraph {\n\n  'a' [label = 'a', color = 'aqua', shape = 'circle'] \n  'b' [label = 'b', color = 'aqua', shape = 'circle'] \n  "| __truncated__
    ##  - attr(*, "class")= chr "dgr_graph"

2 - Language
------------

-   DOT (Graphviz)
-   Mermaid
-   R

3 - Querying Graph
------------------

### Statistics

`node_info`, `edge_info`, `node_count`...

### Nodes and Edge Selection (Subgraph)

`select_nodes`, `select_nodes_by_id`, `select_nodes_in_neighborhood`...

### Traversals

`trav_out`, `trav_in`, `get_path`...

### No algorithms, No Modelling

See `igraph` package...

### Alternative: Direct processing of EDF & NDF

More efficient Data wrangling packages `dplyr`, `tidyr`...

4 - Visualizing Graph
---------------------

### Node and Edge Attributes

Color, Shape, Font, Fontsize...

### Layout

-   Graphviz Engine (`grViz()`) Layout: dot,neato,twopi,circo (See example \#3)
-   Mermaid Engine (`mermaid()`) Layout: Gantt Chart
-   vizNetwork
-   vivagraph

############# 

Example 1: Data Modeling Schema | Focus: the DOT Language
=========================================================

Input: GTFS Format | <https://developers.google.com/transit/gtfs/reference#feed-files>
--------------------------------------------------------------------------------------

<table style="width:19%;">
<colgroup>
<col width="2%" />
<col width="16%" />
</colgroup>
<thead>
<tr class="header">
<th>Filename</th>
<th align="left">Defines</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>agency.txt</td>
<td align="left">One or more transit agencies that provide the data in this feed. Ex: DB, BVG</td>
</tr>
<tr class="even">
<td>stops.txt</td>
<td align="left">Individual locations where vehicles pick up or drop off passengers. Includes Latitude + Longitudes Ex: Alexanderplatz.</td>
</tr>
<tr class="odd">
<td>routes.txt</td>
<td align="left">Transit routes. A route is a group of trips that are displayed to riders as a single service. Ex: U2 Line</td>
</tr>
<tr class="even">
<td>trips.txt</td>
<td align="left">Trips for each route. A trip is a sequence of two or more stops that occurs at specific time. Ex: The U2 U-Bahn leaving today from klosterstr. Station at 13:01</td>
</tr>
<tr class="odd">
<td>stop_times.txt</td>
<td align="left">Times that a vehicle arrives at and departs from individual stops for each trip.</td>
</tr>
<tr class="even">
<td>calendar.txt</td>
<td align="left">Dates for service IDs using a weekly schedule. Specify when service starts and ends, as well as days of the week where service is available.</td>
</tr>
</tbody>
</table>

Editing DOT Code in RStudio
---------------------------

![](%7B%7B%20site.url%20%7D%7D/images/BRUG-RDBM-RStudio2.png){:class="img-responsive"}

Outputing with RMarkdown
------------------------

### in your R Code chunk

``` r
DiagrammeR::grViz("RDBM.gv")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-1c99fb43d91b69d1de07">{"x":{"diagram":"RDBM.gv","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
############# 

Example 2: Network | Focus = Creating NDF, EDF & Querying them
==============================================================

Input: Berlin Public Transportation Timetables
----------------------------------------------

### Open Data

<https://daten.berlin.de/datensaetze/vbb-fahrplandaten-ende-juni-bis-dezember-2016>

### Download

``` r
temp <- tempfile()
download.file("http://www.vbb.de/de/download/GTFS_VBB_EndeJun_Dez2016.zip",temp)
stops <- read.table(unz(temp,filename="stops.txt"),header=TRUE,sep=',',
                    fileEncoding="UTF-8",stringsAsFactors = FALSE)
stop_times <- read.table(unz(temp,filename="stop_times.txt"),header=TRUE,sep=',',
                         fileEncoding="UTF-8",stringsAsFactors = FALSE)
trips <- read.table(unz(temp,filename="trips.txt"),header=TRUE,sep=',',
                    fileEncoding="UTF-8",stringsAsFactors = FALSE)
routes <- read.table(unz(temp,filename="routes.txt"),header=TRUE,sep=',',
                     fileEncoding="UTF-8",stringsAsFactors = FALSE)
unlink(temp)
```

Data Wrangling: U-Bahn Stations EDF
-----------------------------------

``` r
library(dplyr)
edf_ubahn<-filter(routes,route_short_name%in%
                    c("U1","U2","U3","U4","U5","U6","U7","U8"))%>%
  select(route_id,route_short_name)%>%
  left_join(trips,by="route_id")%>%
  group_by(trip_headsign,route_short_name)%>%
  summarise(trip_id=first(trip_id))%>%
  ungroup()%>%
  left_join(stop_times,by=c("trip_id"))%>%
  left_join(transmute(stop_times,
                      trip_id=trip_id,
                      stop_id_to=stop_id,
                      arrival_time_to=arrival_time,
                      stop_sequence=stop_sequence-1),
            by=c("trip_id","stop_sequence"))%>%
  transmute(from=stop_id,to=stop_id_to,type=route_short_name)%>%
  filter(!is.na(to))%>%unique%>%
  mutate(color=ifelse(type=="U1","blue",NA)%>%
                       ifelse(type=="U2","red",.)%>%ifelse(type=="U3","green",.)%>%
                       ifelse(type=="U4","lime",.)%>%ifelse(type=="U5","gold",.)%>%
                       ifelse(type=="U6","purple",.)%>%ifelse(type=="U7","purple",.)%>%
                       ifelse(type=="U8","purple",.))%>%
  as.data.frame
```

    ## Warning in filter_impl(.data, dots): '.Random.seed' is not an integer
    ## vector but of type 'NULL', so ignored

Data Wrangling: U-Bahn Stations NDF
-----------------------------------

``` r
library(dplyr)
ndf_ubahn<-filter(routes,route_short_name%in%
                    c("U1","U2","U3","U4","U5","U6","U7","U8"))%>%
  select(route_id,route_short_name)%>%
  left_join(trips,by="route_id")%>%
  group_by(trip_headsign,route_short_name)%>%
  summarise(trip_id=first(trip_id))%>%
  ungroup()%>%
  left_join(stop_times,by=c("trip_id"))%>%
  transmute(nodes=stop_id,stop_id=stop_id)%>%
  unique%>%
  left_join(stops,by="stop_id")%>%
  transmute(nodes,label=stop_name,stop_lat,stop_lon)%>%
  as.data.frame
```

Input for graph Creation
------------------------

``` r
head(edf_ubahn)
```

    ##      from      to type color
    ## 1 9175007 9175006   U5  gold
    ## 2 9175006 9175005   U5  gold
    ## 3 9175005 9175004   U5  gold
    ## 4 9175004 9175001   U5  gold
    ## 5 9175001 9175004   U5  gold
    ## 6 9175004 9175005   U5  gold

``` r
head(ndf_ubahn)
```

    ##     nodes                           label stop_lat stop_lon
    ## 1 9175007          U Hellersdorf (Berlin) 52.53595 13.60579
    ## 2 9175006     U Cottbusser Platz (Berlin) 52.53396 13.59689
    ## 3 9175005 U Neue Grottkauer Str. (Berlin) 52.52824 13.59078
    ## 4 9175004       U Kaulsdorf-Nord (Berlin) 52.52144 13.58876
    ## 5 9175001           S+U Wuhletal (Berlin) 52.51254 13.57548
    ## 6 9130002             S+U Pankow (Berlin) 52.56728 13.41228

Create and visualize U-Bahn Graph
---------------------------------

``` r
graph_ubahn<-DiagrammeR::create_graph(ndf_ubahn,edf_ubahn)
DiagrammeR::render_graph(graph_ubahn,output="visNetwork")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-1c36c6501045f7d618c0">{"x":{"nodes":{"id":["9175007","9175006","9175005","9175004","9175001","9130002","9130011","9110001","9110006","9110005","9100016","9100703","9175010","9175015","9171006","9171005","9161002","9161512","9160701","9160005","9120001","9120009","9120008","9120025","9120006","9100017","9100704","9079221","9079201","9079202","9078101","9016201","9013102","9013101","9100008","9100004","9100705","9100051","9100023","9007110","9007103","9007102","9096197","9096410","9096458","9086160","9085104","9085203","9085202","9009202","9009203","9056102","9055101","9055102","9054101","9054105","9022201","9023101","9023201","9056101","9056104","9017103","9005252","9100720","9100010","9100701","9100012","9100013","9100014","9100015","9083201","9083101","9083102","9082201","9082202","9080402","9080401","9080201","9080202","9078272","9078103","9078102","9016202","9016101","9017101","9017104","9057103","9054102","9054103","9044201","9041102","9041101","9041201","9023302","9024202","9024201","9022202","9019204","9020201","9018101","9018102","9035101","9036101","9034101","9034102","9029301","9029302","9089301","9088202","9088201","9086101","9087101","9086102","9011102","9011101","9009103","9009102","9009104","9008102","9100501","9100009","9100019","9100001","9100027","9100011","9012102","9012103","9017102","9068101","9068201","9042101","9023202","9005201","9013103","9014101","9014102","9120004","9068202","9068302","9069271","9070101","9070301","9043101","9045102","9045101","9051202","9033101","9050201","9050282","9051301","9051201","9051303","9051302","9022101","9026202","9026201","9026101","9025203","9025202","9023203","9023301"],"label":["U Hellersdorf (Berlin)","U Cottbusser Platz (Berlin)","U Neue Grottkauer Str. (Berlin)","U Kaulsdorf-Nord (Berlin)","S+U Wuhletal (Berlin)","S+U Pankow (Berlin)","U Vinetastr. (Berlin)","S+U Schönhauser Allee (Berlin)","U Eberswalder Str. (Berlin)","U Senefelderplatz (Berlin)","U Rosa-Luxemburg-Platz (Berlin)","S+U Alexanderplatz (Berlin) [U2]","U Hönow (Berlin)","U Louis-Lewin-Str. (Berlin)","U Elsterwerdaer Platz (Berlin)","U Biesdorf-Süd (Berlin)","U Tierpark (Berlin)","U Friedrichsfelde (Berlin)","S+U Lichtenberg (Berlin) [U5]","U Magdalenenstr. (Berlin)","S+U Frankfurter Allee (Berlin)","U Samariterstr. (Berlin)","U Frankfurter Tor (Berlin)","U Weberwiese (Berlin)","U Strausberger Platz (Berlin)","U Schillingstr. (Berlin)","S+U Alexanderplatz (Berlin) [U5]","S+U Hermannstr. (Berlin)","U Leinestr. (Berlin)","U Boddinstr. (Berlin)","U Hermannplatz (Berlin)","U Schönleinstr. (Berlin)","U Kottbusser Tor (Berlin)","U Moritzplatz (Berlin)","U Heinrich-Heine-Str. (Berlin)","S+U Jannowitzbrücke (Berlin)","S+U Alexanderplatz (Berlin) [U8]","U Weinmeisterstr. (Berlin)","U Rosenthaler Platz (Berlin)","U Bernauer Str. (Berlin)","U Voltastr. (Berlin)","S+U Gesundbrunnen Bhf (Berlin)","S+U Wittenau (Berlin) [U8]","U Rathaus Reinickendorf (Berlin)","S+U Karl-Bonhoeffer-Nervenklinik (Berlin)","U Lindauer Allee (Berlin)","U Paracelsus-Bad (Berlin)","U Residenzstr. (Berlin)","U Franz-Neumann-Platz (Berlin)","U Osloer Str. (Berlin)","U Pankstr. (Berlin)","U Nollendorfplatz (Berlin)","U Viktoria-Luise-Platz (Berlin)","U Bayerischer Platz (Berlin)","U Rathaus Schöneberg (Berlin)","S+U Innsbrucker Platz (Berlin)","U Deutsche Oper (Berlin)","U Ernst-Reuter-Platz (Berlin)","S+U Zoologischer Garten Bhf (Berlin)","U Wittenbergplatz (Berlin)","U Bülowstr. (Berlin)","U Gleisdreieck (Berlin)","U Mendelssohn-Bartholdy-Park (Berlin)","S+U Potsdamer Platz (Bln) [U2]","U Mohrenstr. (Berlin)","U Stadtmitte U2 (Berlin)","U Hausvogteiplatz (Berlin)","U Spittelmarkt (Berlin)","U Märkisches Museum (Berlin)","U Klosterstr. (Berlin)","U Rudow (Berlin)","U Zwickauer Damm (Berlin)","U Wutzkyallee (Berlin)","U Lipschitzallee (Berlin)","U Johannisthaler Chaussee (Berlin)","U Britz-Süd (Berlin)","U Parchimer Allee (Berlin)","U Blaschkoallee (Berlin)","U Grenzallee (Berlin)","S+U Neukölln (Berlin) [U7]","U Karl-Marx-Str. (Berlin)","U Rathaus Neukölln (Berlin)","U Südstern (Berlin)","U Gneisenaustr. (Berlin)","U Mehringdamm (Berlin)","U Möckernbrücke (Berlin)","S+U Yorckstr. (Berlin)","U Kleistpark (Berlin)","U Eisenacher Str. (Berlin)","U Berliner Str. (Berlin)","U Blissestr. (Berlin)","U Fehrbelliner Platz (Berlin)","U Konstanzer Str. (Berlin)","U Adenauerplatz (Berlin)","U Wilmersdorfer Str. (Berlin)","U Bismarckstr. (Berlin)","U Richard-Wagner-Platz (Berlin)","U Mierendorffplatz (Berlin)","S+U Jungfernheide Bhf (Berlin)","U Jakob-Kaiser-Platz (Berlin)","U Halemweg (Berlin)","U Siemensdamm (Berlin)","U Rohrdamm (Berlin)","U Paulsternstr. (Berlin)","U Haselhorst (Berlin)","U Altstadt Spandau (Berlin)","S+U Rathaus Spandau (Berlin)","U Alt-Tegel (Berlin)","U Borsigwerke (Berlin)","U Holzhauser Str. (Berlin)","U Otisstr. (Berlin)","U Scharnweberstr. (Berlin)","U Kurt-Schumacher-Platz (Berlin)","U Afrikanische Str. (Berlin)","U Rehberge (Berlin)","U Seestr. (Berlin)","U Leopoldplatz (Berlin)","S+U Wedding (Berlin)","U Reinickendorfer Str. (Berlin)","U Schwartzkopffstr. (Berlin)","U Naturkundemuseum (Berlin)","U Oranienburger Tor (Berlin)","S+U Friedrichstr. Bhf (Berlin)","U Französische Str. (Berlin)","U Stadtmitte (Berlin)","U Kochstr./Checkpoint Charlie (Berlin)","U Hallesches Tor (Berlin)","U Platz der Luftbrücke (Berlin)","U Paradestr. (Berlin)","S+U Tempelhof (Berlin)","U Spichernstr. (Berlin)","U Augsburger Str. (Berlin)","U Kurfürstenstr. (Berlin)","U Prinzenstr. (Berlin)","U Görlitzer Bahnhof (Berlin)","U Schlesisches Tor (Berlin)","S+U Warschauer Str. (Berlin)","U Alt-Tempelhof (Berlin)","U Kaiserin-Augusta-Str. (Berlin)","U Ullsteinstr. (Berlin)","U Westphalweg (Berlin)","U Alt-Mariendorf (Berlin)","U Hohenzollernplatz (Berlin)","S+U Heidelberger Platz (Berlin)","U Rüdesheimer Platz (Berlin)","U Breitenbachplatz (Berlin)","U Zitadelle (Berlin)","U Krumme Lanke (Berlin)","U Onkel Toms Hütte (Berlin)","U Oskar-Helene-Heim (Berlin)","U Thielplatz (Berlin)","U Dahlem-Dorf (Berlin)","U Podbielskiallee (Berlin)","U Sophie-Charlotte-Platz (Berlin)","U Kaiserdamm (Berlin)","U Theodor-Heuss-Platz (Berlin)","U Neu-Westend (Berlin)","U Olympia-Stadion (Berlin)","U Ruhleben (Berlin)","U Kurfürstendamm (Berlin)","U Uhlandstr. (Berlin)"],"stop_lat":["52.535946","52.533963","52.52824","52.521436","52.512537","52.567281","52.559517","52.549336","52.541085","52.532622","52.528191","52.522078","52.538105","52.539135","52.504643","52.499517","52.497236","52.505895","52.511484","52.512214","52.513613","52.514662","52.515772","52.516848","52.518025","52.520316","52.521607","52.467181","52.472874","52.479745","52.486957","52.493179","52.499047","52.503739","52.510858","52.5155","52.521619","52.525376","52.529781","52.537994","52.54193","52.548637","52.595665","52.588218","52.578169","52.575394","52.574534","52.570843","52.563854","52.556938","52.552255","52.499644","52.496169","52.488654","52.483332","52.4781","52.511827","52.511582","52.506921","52.502109","52.497657","52.499587","52.503806","52.509071","52.511519","52.512169","52.513361","52.511301","52.512007","52.517229","52.415614","52.423032","52.423152","52.424645","52.429253","52.437076","52.445344","52.452743","52.463516","52.468764","52.476429","52.481146","52.489219","52.491252","52.493575","52.498944","52.492766","52.490845","52.489529","52.487047","52.486347","52.490201","52.493567","52.500086","52.505834","52.511513","52.517154","52.525978","52.530275","52.536985","52.536703","52.537026","52.536904","52.538098","52.538718","52.539161","52.535798","52.589649","52.582139","52.576252","52.571122","52.567111","52.563483","52.560862","52.55667","52.55047","52.546493","52.542732","52.539895","52.535397","52.531254","52.525163","52.52027","52.514771","52.511495","52.506673","52.497774","52.484977","52.478142","52.470694","52.496582","52.500557","52.49981","52.498274","52.499035","52.501147","52.505889","52.46593","52.460512","52.45345","52.445801","52.439641","52.493833","52.479446","52.472462","52.467342","52.537522","52.442615","52.450146","52.450419","52.451","52.457695","52.464172","52.51097","52.509971","52.509798","52.516409","52.517048","52.525587","52.503763","52.502742"],"stop_lon":["13.605794","13.596894","13.590777","13.588763","13.575478","13.412279","13.41377","13.415138","13.41216","13.412625","13.410405","13.413598","13.634541","13.619707","13.560762","13.547326","13.523626","13.512791","13.497369","13.489439","13.4753","13.465347","13.454085","13.443278","13.432208","13.421895","13.413111","13.431704","13.4284","13.425782","13.42472","13.422241","13.417748","13.410947","13.416169","13.418027","13.412125","13.405305","13.401393","13.396231","13.393157","13.388372","13.334648","13.325568","13.332921","13.339047","13.347532","13.360635","13.364283","13.373284","13.381837","13.353825","13.343264","13.340237","13.341989","13.342875","13.30942","13.322581","13.332707","13.342561","13.362452","13.374293","13.374719","13.377977","13.383798","13.389711","13.395346","13.402352","13.408767","13.412455","13.496734","13.484371","13.47482","13.463109","13.453851","13.447668","13.449925","13.448976","13.444828","13.441909","13.439805","13.434807","13.407685","13.395382","13.388153","13.383256","13.370429","13.360917","13.350276","13.331355","13.321618","13.314519","13.310084","13.307348","13.306885","13.305286","13.307221","13.305715","13.299064","13.293661","13.286578","13.273323","13.26287","13.248593","13.232309","13.206763","13.199891","13.283821","13.290122","13.295083","13.303074","13.311524","13.327328","13.333502","13.341013","13.351969","13.359395","13.36606","13.370393","13.377033","13.382415","13.387587","13.387153","13.390088","13.389719","13.390863","13.39176","13.386351","13.386725","13.385754","13.330613","13.336771","13.362814","13.406531","13.428468","13.441791","13.448721","13.385796","13.384905","13.384771","13.385561","13.387456","13.324051","13.311843","13.314387","13.309276","13.217625","13.24036","13.254016","13.26891","13.281651","13.290011","13.295203","13.297463","13.281967","13.272977","13.25991","13.2505","13.241902","13.331419","13.326233"]},"edges":{"from":["9175007","9175006","9175005","9175004","9175001","9175004","9175005","9175006","9130002","9130011","9110001","9110006","9110005","9100016","9175010","9175015","9175001","9171006","9171005","9161002","9161512","9160701","9160005","9120001","9120009","9120008","9120025","9120006","9100017","9100704","9100017","9120006","9120025","9120008","9120009","9079221","9079201","9079202","9078101","9016201","9013102","9013101","9100008","9100004","9100705","9100051","9100023","9007110","9007103","9096197","9096410","9096458","9086160","9085104","9085203","9085202","9009202","9009203","9007102","9007103","9007110","9100023","9100051","9100705","9100004","9100008","9013101","9013102","9016201","9078101","9079202","9079201","9056102","9055101","9055102","9054101","9022201","9023101","9023201","9056101","9056102","9056104","9017103","9005252","9100720","9100010","9100701","9100012","9100013","9100014","9100015","9100703","9100016","9110005","9110006","9110001","9130011","9100703","9100015","9100014","9100013","9100012","9100701","9100010","9083201","9083101","9083102","9082201","9082202","9080402","9080401","9080201","9080202","9078272","9078103","9078102","9078101","9016202","9016101","9017101","9017104","9057103","9054102","9054103","9055102","9044201","9041102","9041101","9041201","9023302","9024202","9024201","9022202","9019204","9020201","9018101","9018102","9035101","9036101","9034101","9034102","9029301","9089301","9088202","9088201","9086101","9087101","9086102","9011102","9011101","9009103","9009102","9009104","9008102","9100501","9100009","9100019","9100001","9100027","9100011","9012102","9012103","9017101","9017102","9068101","9042101","9023202","9056101","9056102","9005201","9017103","9017104","9012103","9013103","9013102","9014101","9014102","9007102","9009203","9009202","9085202","9085203","9085104","9086160","9096458","9096410","9120001","9160005","9160701","9161512","9161002","9171005","9171006","9120004","9014102","9014101","9013102","9013103","9012103","9017104","9017103","9005201","9056102","9056101","9100720","9005252","9017103","9056104","9056102","9056101","9068201","9068202","9068302","9069271","9070101","9070301","9070101","9069271","9068302","9068202","9068201","9068101","9017102","9017101","9012103","9012102","9100011","9100027","9100001","9100019","9100009","9100501","9008102","9009104","9009102","9009103","9011101","9011102","9086102","9087101","9086101","9088201","9088202","9056101","9023202","9042101","9043101","9041101","9045102","9045101","9056102","9056101","9023202","9042101","9043101","9041101","9045102","9045101","9029302","9029301","9033101","9034102","9034101","9036101","9035101","9018102","9018101","9020201","9019204","9022202","9024201","9024202","9023302","9041201","9041101","9041102","9044201","9055102","9054103","9054102","9057103","9017104","9017101","9016101","9016202","9078101","9078102","9078103","9078272","9080202","9080201","9080401","9023201","9023101","9050201","9050282","9051301","9051201","9051303","9051302","9051202","9045101","9045102","9175007","9175015","9051202","9051302","9051303","9051201","9051301","9050282","9041101","9043101","9042101","9023202","9056101","9054105","9054101","9055102","9055101","9022201","9024201","9022101","9026202","9026201","9026101","9025203","9026101","9026201","9026202","9022101","9024201","9080402","9082202","9082201","9083102","9083101","9025203","9056101","9023202","9056101","9023203"],"to":["9175006","9175005","9175004","9175001","9175004","9175005","9175006","9175007","9130011","9110001","9110006","9110005","9100016","9100703","9175015","9175007","9171006","9171005","9161002","9161512","9160701","9160005","9120001","9120009","9120008","9120025","9120006","9100017","9100704","9100017","9120006","9120025","9120008","9120009","9120001","9079201","9079202","9078101","9016201","9013102","9013101","9100008","9100004","9100705","9100051","9100023","9007110","9007103","9007102","9096410","9096458","9086160","9085104","9085203","9085202","9009202","9009203","9007102","9007103","9007110","9100023","9100051","9100705","9100004","9100008","9013101","9013102","9016201","9078101","9079202","9079201","9079221","9055101","9055102","9054101","9054105","9023101","9023201","9056101","9056102","9056104","9017103","9005252","9100720","9100010","9100701","9100012","9100013","9100014","9100015","9100703","9100016","9110005","9110006","9110001","9130011","9130002","9100015","9100014","9100013","9100012","9100701","9100010","9100720","9083101","9083102","9082201","9082202","9080402","9080401","9080201","9080202","9078272","9078103","9078102","9078101","9016202","9016101","9017101","9017104","9057103","9054102","9054103","9055102","9044201","9041102","9041101","9041201","9023302","9024202","9024201","9022202","9019204","9020201","9018101","9018102","9035101","9036101","9034101","9034102","9029301","9029302","9088202","9088201","9086101","9087101","9086102","9011102","9011101","9009103","9009102","9009104","9008102","9100501","9100009","9100019","9100001","9100027","9100011","9012102","9012103","9017101","9017102","9068101","9068201","9023202","9056101","9056102","9005201","9017103","9017104","9012103","9013103","9013102","9014101","9014102","9120004","9009203","9009202","9085202","9085203","9085104","9086160","9096458","9096410","9096197","9160005","9160701","9161512","9161002","9171005","9171006","9175001","9014102","9014101","9013102","9013103","9012103","9017104","9017103","9005201","9056102","9056101","9023201","9005252","9017103","9056104","9056102","9056101","9023201","9068202","9068302","9069271","9070101","9070301","9070101","9069271","9068302","9068202","9068201","9068101","9017102","9017101","9012103","9012102","9100011","9100027","9100001","9100019","9100009","9100501","9008102","9009104","9009102","9009103","9011101","9011102","9086102","9087101","9086101","9088201","9088202","9089301","9023202","9042101","9043101","9041101","9045102","9045101","9051202","9056101","9023202","9042101","9043101","9041101","9045102","9045101","9051202","9029301","9033101","9034102","9034101","9036101","9035101","9018102","9018101","9020201","9019204","9022202","9024201","9024202","9023302","9041201","9041101","9041102","9044201","9055102","9054103","9054102","9057103","9017104","9017101","9016101","9016202","9078101","9078102","9078103","9078272","9080202","9080201","9080401","9080402","9023101","9022201","9050282","9051301","9051201","9051303","9051302","9051202","9045101","9045102","9041101","9175015","9175010","9051302","9051303","9051201","9051301","9050282","9050201","9043101","9042101","9023202","9056101","9056102","9054101","9055102","9055101","9056102","9024201","9022101","9026202","9026201","9026101","9025203","9026101","9026201","9026202","9022101","9024201","9022201","9082202","9082201","9083102","9083101","9083201","9025202","9023202","9042101","9023203","9023301"],"type":["U5","U5","U5","U5","U5","U5","U5","U5","U2","U2","U2","U2","U2","U2","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U5","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U8","U4","U4","U4","U4","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U8","U8","U8","U8","U8","U8","U8","U8","U8","U5","U5","U5","U5","U5","U5","U5","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U2","U2","U2","U2","U2","U2","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U6","U2","U2","U2","U2","U2","U2","U2","U3","U3","U3","U3","U3","U3","U3","U3","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U7","U2","U2","U3","U3","U3","U3","U3","U3","U3","U3","U3","U5","U5","U3","U3","U3","U3","U3","U3","U3","U3","U3","U3","U3","U4","U4","U4","U4","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U2","U7","U7","U7","U7","U7","U2","U1","U1","U1","U1"],"color":["gold","gold","gold","gold","gold","gold","gold","gold","red","red","red","red","red","red","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","gold","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","lime","lime","lime","lime","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","red","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","purple","purple","purple","purple","purple","purple","purple","purple","purple","gold","gold","gold","gold","gold","gold","gold","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","red","red","red","red","red","red","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","red","red","red","red","red","red","red","green","green","green","green","green","green","green","green","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","purple","red","red","green","green","green","green","green","green","green","green","green","gold","gold","green","green","green","green","green","green","green","green","green","green","green","lime","lime","lime","lime","red","red","red","red","red","red","red","red","red","red","red","red","purple","purple","purple","purple","purple","red","blue","blue","blue","blue"]},"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":{"to":{"enabled":true,"scaleFactor":1}}},"physics":{"stabilization":{"enabled":true,"onlyDynamicEdges":false,"fit":true}},"layout":{"improvedLayout":true}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
Sub-network | Querying EDF & NDF directly
-----------------------------------------

``` r
# Function: get connected nodes within a given number of step
recursive_dep<-function(edf,ndf,nodes,number_step) {
  if (number_step == 0) return(nodes) else return(
    union(dplyr::filter(edf,from%in%nodes)%>%.$to,nodes)%>%
  recursive_dep(edf,ndf,nodes=.,number_step-1))
}
# Nodes Connected to Nollendorf with 3 step
nodes_sub<-recursive_dep(edf=edf_ubahn,ndf=ndf_ubahn,
                         nodes=dplyr::filter(ndf_ubahn,grepl('Nollendorf',label))%>%.$nodes,
                         number_step=3)
# Your Input object
ndf_sub<-data.frame(nodes=nodes_sub)%>%dplyr::left_join(ndf_ubahn,by="nodes")
edf_sub<-dplyr::filter(edf_ubahn,from%in%nodes_sub)
```

Visualize Sub Network
---------------------

``` r
graph_sub<-DiagrammeR::create_graph(ndf_sub,edf_sub)
DiagrammeR::render_graph(graph_sub,output="visNetwork")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-39c984e5f6c92b761334">{"x":{"nodes":{"id":["9055101","9055102","9054101","9056101","9056102","9056104","9017103","9005252","9044201","9005201","9017104","9023201","9023202","9042101","9054103","9023101","9023203","9023301"],"label":["U Viktoria-Luise-Platz (Berlin)","U Bayerischer Platz (Berlin)","U Rathaus Schöneberg (Berlin)","U Wittenbergplatz (Berlin)","U Nollendorfplatz (Berlin)","U Bülowstr. (Berlin)","U Gleisdreieck (Berlin)","U Mendelssohn-Bartholdy-Park (Berlin)","U Berliner Str. (Berlin)","U Kurfürstenstr. (Berlin)","U Möckernbrücke (Berlin)","S+U Zoologischer Garten Bhf (Berlin)","U Augsburger Str. (Berlin)","U Spichernstr. (Berlin)","U Eisenacher Str. (Berlin)","U Ernst-Reuter-Platz (Berlin)","U Kurfürstendamm (Berlin)","U Uhlandstr. (Berlin)"],"stop_lat":["52.496169","52.488654","52.483332","52.502109","52.499644","52.497657","52.499587","52.503806","52.487047","52.49981","52.498944","52.506921","52.500557","52.496582","52.489529","52.511582","52.503763","52.502742"],"stop_lon":["13.343264","13.340237","13.341989","13.342561","13.353825","13.362452","13.374293","13.374719","13.331355","13.362814","13.383256","13.332707","13.336771","13.330613","13.350276","13.322581","13.331419","13.326233"]},"edges":{"from":["9056102","9055101","9055102","9054101","9023101","9023201","9056101","9056102","9056104","9017103","9005252","9017104","9054103","9055102","9044201","9042101","9023202","9056101","9056102","9005201","9017103","9017104","9017104","9017103","9005201","9056102","9056101","9005252","9017103","9056104","9056102","9056101","9056101","9023202","9042101","9056102","9056101","9023202","9042101","9044201","9055102","9054103","9017104","9023201","9023101","9042101","9023202","9056101","9054101","9055102","9055101","9056101","9023202","9056101","9023203"],"to":["9055101","9055102","9054101","9054105","9023201","9056101","9056102","9056104","9017103","9005252","9100720","9057103","9055102","9044201","9041102","9023202","9056101","9056102","9005201","9017103","9017104","9012103","9017103","9005201","9056102","9056101","9023201","9017103","9056104","9056102","9056101","9023201","9023202","9042101","9043101","9056101","9023202","9042101","9043101","9055102","9054103","9054102","9017101","9023101","9022201","9023202","9056101","9056102","9055102","9055101","9056102","9023202","9042101","9023203","9023301"],"type":["U4","U4","U4","U4","U2","U2","U2","U2","U2","U2","U2","U7","U7","U7","U7","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U1","U2","U2","U2","U2","U2","U2","U2","U2","U3","U3","U3","U3","U7","U7","U7","U7","U2","U2","U3","U3","U3","U4","U4","U4","U1","U1","U1","U1"],"color":["lime","lime","lime","lime","red","red","red","red","red","red","red","purple","purple","purple","purple","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","red","red","red","red","red","red","red","red","green","green","green","green","purple","purple","purple","purple","red","red","green","green","green","lime","lime","lime","blue","blue","blue","blue"]},"options":{"width":"100%","height":"100%","nodes":{"shape":"dot"},"manipulation":{"enabled":false},"edges":{"arrows":{"to":{"enabled":true,"scaleFactor":1}}},"physics":{"stabilization":{"enabled":true,"onlyDynamicEdges":false,"fit":true}},"layout":{"improvedLayout":true}},"groups":null,"width":null,"height":null,"idselection":{"enabled":false},"byselection":{"enabled":false},"main":null,"submain":null,"footer":null},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
############# 

Example 3: Package Dependencies | Focus: Graphviz Layout
========================================================

Getting the Nodes from CRAN
---------------------------

``` r
library(magrittr)
con <- url("http://cran.r-project.org/src/contrib/PACKAGES") # DESCRIPTION Files 
ndf_pack<- read.dcf(con, all = TRUE)%>%  # Parsing dcf into a Data Frame. 1 Line = 1 Node = 1 Package
  dplyr::mutate(nodes=Package,label=Package) # Adding required columns `nodes` and `label` for NDF
close(con)
str(ndf_pack,width=100,strict.width="cut") # Quick check 
```

    ## 'data.frame':    9315 obs. of  16 variables:
    ##  $ Package              : chr  "A3" "abbyyR" "abc" "ABCanalysis" ...
    ##  $ Version              : chr  "1.0.0" "0.5.0" "2.1" "1.1.2" ...
    ##  $ Depends              : chr  "R (>= 2.15.0), xtable, pbapply" "R (>= 3.2.0)" "R (>= 2.10), abc."..
    ##  $ Suggests             : chr  "randomForest, e1071" "testthat, rmarkdown, knitr (>= 1.11)" NA NA ..
    ##  $ License              : chr  "GPL (>= 2)" "MIT + file LICENSE" "GPL (>= 3)" "GPL-3" ...
    ##  $ NeedsCompilation     : chr  "no" "no" "no" "no" ...
    ##  $ Imports              : chr  NA "httr, XML, curl, readr, progress" NA "plotrix" ...
    ##  $ LinkingTo            : chr  NA NA NA NA ...
    ##  $ Enhances             : chr  NA NA NA NA ...
    ##  $ License_restricts_use: chr  NA NA NA NA ...
    ##  $ OS_type              : chr  NA NA NA NA ...
    ##  $ Priority             : chr  NA NA NA NA ...
    ##  $ License_is_FOSS      : chr  NA NA NA NA ...
    ##  $ Archs                : chr  NA NA NA NA ...
    ##  $ nodes                : chr  "A3" "abbyyR" "abc" "ABCanalysis" ...
    ##  $ label                : chr  "A3" "abbyyR" "abc" "ABCanalysis" ...

Defining the Dependencies EDF
-----------------------------

For the `Imports` Dependencies

``` r
edf_import<-ndf_pack%>%
  dplyr::select(Package,Imports)%>%
  tidyr::separate(col=Imports,
             into=paste0("V",1:35),
             sep=", ",
             remove=TRUE)%>%
  tidyr::gather(key=foo,
                value=to,
                -Package)%>%
  dplyr::transmute(from=Package,
                   to=to,
                   rel="Import",
                   color="DarkRed")%>%
  dplyr::filter(!is.na(to))%>%
  tidyr::separate(col=to,
                into="to",
                sep="\\s",
                extra="drop")
```

Creating in the same way a `edf_depends` for the `Depends`...

Create Dependencies Graph for `DiagrammeR` Package
--------------------------------------------------

``` r
edf_pack<-DiagrammeR::combine_edges(edf_import,
                                     edf_depends) # Like rbind but different columns allowed
# Nodes Connected to DiagrammeR with 30 step (enough to get them all!)
nodes_DiagrammeR<-union(gtools::getDependencies("DiagrammeR",available=FALSE),"DiagrammeR")
# EDF & NDF
ndf_DiagrammeR<-data.frame(nodes=nodes_DiagrammeR)%>%dplyr::left_join(ndf_pack,by="nodes")
edf_DiagrammeR<-dplyr::filter(edf_pack,from%in%nodes_DiagrammeR)
# The Graph
graph_DiagrammeR<-DiagrammeR::create_graph(ndf_DiagrammeR,
                                           edf_DiagrammeR,
                                           graph_attrs = c("layout = dot","overlap=FALSE"),
                                           node_attrs = c("fontname = Helvetica"))
# Specific Color for the DiagrammeR Node
graph_DiagrammeR <- DiagrammeR::set_node_attrs(graph_DiagrammeR,
                                              nodes = c("DiagrammeR"),
                                              node_attr = "fillcolor", 
                                              values = "blue")
```

DOT Layout
----------

Flows the directed graph in the direction of rank

``` r
DiagrammeR::render_graph(graph_DiagrammeR,output="graph")
```

![](figures/Dep-Dot.png)

twopi Layout
------------

Concentric Circles

``` r
graph_DiagrammeR<-DiagrammeR::set_global_graph_attrs(graph_DiagrammeR,"graph","layout","twopi")
DiagrammeR::render_graph(graph_DiagrammeR,output="graph")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-6d16b2c70bb0486f1cbe">{"x":{"diagram":"digraph {\n\ngraph [layout = dot,\n       overlap=FALSE,\n       layout = twopi]\n\nnode [fontname = Helvetica]\n\n  \"xtable\" [label = \"xtable\"] \n  \"iterators\" [label = \"iterators\"] \n  \"gtable\" [label = \"gtable\"] \n  \"digest\" [label = \"digest\"] \n  \"pkgmaker\" [label = \"pkgmaker\"] \n  \"registry\" [label = \"registry\"] \n  \"rngtools\" [label = \"rngtools\"] \n  \"gridBase\" [label = \"gridBase\"] \n  \"colorspace\" [label = \"colorspace\"] \n  \"foreach\" [label = \"foreach\"] \n  \"doParallel\" [label = \"doParallel\"] \n  \"ggplot2\" [label = \"ggplot2\"] \n  \"reshape2\" [label = \"reshape2\"] \n  \"htmltools\" [label = \"htmltools\"] \n  \"jsonlite\" [label = \"jsonlite\"] \n  \"yaml\" [label = \"yaml\"] \n  \"magrittr\" [label = \"magrittr\"] \n  \"NMF\" [label = \"NMF\"] \n  \"irlba\" [label = \"irlba\"] \n  \"stringi\" [label = \"stringi\"] \n  \"RColorBrewer\" [label = \"RColorBrewer\"] \n  \"dichromat\" [label = \"dichromat\"] \n  \"plyr\" [label = \"plyr\"] \n  \"munsell\" [label = \"munsell\"] \n  \"labeling\" [label = \"labeling\"] \n  \"Rcpp\" [label = \"Rcpp\"] \n  \"htmlwidgets\" [label = \"htmlwidgets\"] \n  \"igraph\" [label = \"igraph\"] \n  \"influenceR\" [label = \"influenceR\"] \n  \"rstudioapi\" [label = \"rstudioapi\"] \n  \"stringr\" [label = \"stringr\"] \n  \"visNetwork\" [label = \"visNetwork\"] \n  \"scales\" [label = \"scales\"] \n  \"DiagrammeR\" [label = \"DiagrammeR\", fillcolor = \"blue\"] \n\"colorspace\"->\"graphics\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"foreach\"->\"codetools\" [color = \"DarkRed\"] \n\"ggplot2\"->\"digest\" [color = \"DarkRed\"] \n\"gridBase\"->\"graphics\" [color = \"DarkRed\"] \n\"gtable\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"utils\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"htmltools\" [color = \"DarkRed\"] \n\"igraph\"->\"Matrix\" [color = \"DarkRed\"] \n\"influenceR\"->\"igraph\" [color = \"DarkRed\"] \n\"irlba\"->\"stats\" [color = \"DarkRed\"] \n\"munsell\"->\"colorspace\" [color = \"DarkRed\"] \n\"NMF\"->\"graphics\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"methods\" [color = \"DarkRed\"] \n\"plyr\"->\"Rcpp\" [color = \"DarkRed\"] \n\"Rcpp\"->\"methods\" [color = \"DarkRed\"] \n\"registry\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"plyr\" [color = \"DarkRed\"] \n\"rngtools\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"stringi\"->\"tools\" [color = \"DarkRed\"] \n\"stringr\"->\"stringi\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"xtable\"->\"stats\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"igraph\" [color = \"DarkRed\"] \n\"foreach\"->\"utils\" [color = \"DarkRed\"] \n\"ggplot2\"->\"grid\" [color = \"DarkRed\"] \n\"gridBase\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"digest\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"jsonlite\" [color = \"DarkRed\"] \n\"igraph\"->\"magrittr\" [color = \"DarkRed\"] \n\"influenceR\"->\"Matrix\" [color = \"DarkRed\"] \n\"irlba\"->\"methods\" [color = \"DarkRed\"] \n\"munsell\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stats\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"tools\" [color = \"DarkRed\"] \n\"Rcpp\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"stringr\" [color = \"DarkRed\"] \n\"rngtools\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"dichromat\" [color = \"DarkRed\"] \n\"stringi\"->\"utils\" [color = \"DarkRed\"] \n\"stringr\"->\"magrittr\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmltools\" [color = \"DarkRed\"] \n\"xtable\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"influenceR\" [color = \"DarkRed\"] \n\"foreach\"->\"iterators\" [color = \"DarkRed\"] \n\"ggplot2\"->\"gtable\" [color = \"DarkRed\"] \n\"htmltools\"->\"Rcpp\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"yaml\" [color = \"DarkRed\"] \n\"igraph\"->\"NMF\" [color = \"DarkRed\"] \n\"influenceR\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stringr\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"codetools\" [color = \"DarkRed\"] \n\"reshape2\"->\"Rcpp\" [color = \"DarkRed\"] \n\"scales\"->\"plyr\" [color = \"DarkRed\"] \n\"stringi\"->\"stats\" [color = \"DarkRed\"] \n\"visNetwork\"->\"jsonlite\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"rstudioapi\" [color = \"DarkRed\"] \n\"ggplot2\"->\"MASS\" [color = \"DarkRed\"] \n\"igraph\"->\"irlba\" [color = \"DarkRed\"] \n\"influenceR\"->\"utils\" [color = \"DarkRed\"] \n\"NMF\"->\"digest\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"munsell\" [color = \"DarkRed\"] \n\"visNetwork\"->\"magrittr\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"stringr\" [color = \"DarkRed\"] \n\"ggplot2\"->\"plyr\" [color = \"DarkRed\"] \n\"NMF\"->\"grid\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"labeling,\" [color = \"DarkRed\"] \n\"visNetwork\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"visNetwork\" [color = \"DarkRed\"] \n\"ggplot2\"->\"scales\" [color = \"DarkRed\"] \n\"NMF\"->\"grDevices,\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"xtable\" [color = \"DarkRed\"] \n\"scales\"->\"Rcpp\" [color = \"DarkRed\"] \n\"visNetwork\"->\"methods\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"scales\" [color = \"DarkRed\"] \n\"ggplot2\"->\"stats\" [color = \"DarkRed\"] \n\"NMF\"->\"colorspace\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"grDevices\" [color = \"DarkRed\"] \n\"NMF\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"NMF\"->\"foreach\" [color = \"DarkRed\"] \n\"NMF\"->\"doParallel,\" [color = \"DarkRed\"] \n\"NMF\"->\"reshape2\" [color = \"DarkRed\"] \n\"colorspace\"->\"R\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"R\" [color = \"DarkSlateBlue\"] \n\"digest\"->\"R\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"R\" [color = \"DarkSlateBlue\"] \n\"foreach\"->\"R\" [color = \"DarkSlateBlue\"] \n\"ggplot2\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gridBase\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"htmltools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"igraph\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"influenceR\"->\"R\" [color = \"DarkSlateBlue\"] \n\"irlba\"->\"Matrix\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"R\" [color = \"DarkSlateBlue\"] \n\"jsonlite\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"R\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"R\" [color = \"DarkSlateBlue\"] \n\"plyr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"RColorBrewer\"->\"R\" [color = \"DarkSlateBlue\"] \n\"Rcpp\"->\"R\" [color = \"DarkSlateBlue\"] \n\"registry\"->\"R\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"scales\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringi\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"visNetwork\"->\"R\" [color = \"DarkSlateBlue\"] \n\"xtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"colorspace\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"foreach(>=\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"iterators(>=\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"registry\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"registry,\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"cluster\" [color = \"DarkSlateBlue\"] \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
neato Layout
------------

Attempts to minimize a global energy function

``` r
graph_DiagrammeR<-DiagrammeR::set_global_graph_attrs(graph_DiagrammeR,"graph","layout","neato")
DiagrammeR::render_graph(graph_DiagrammeR,output="graph")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-eb37f9657d58cecc7082">{"x":{"diagram":"digraph {\n\ngraph [layout = dot,\n       overlap=FALSE,\n       layout = twopi,\n       layout = neato]\n\nnode [fontname = Helvetica]\n\n  \"xtable\" [label = \"xtable\"] \n  \"iterators\" [label = \"iterators\"] \n  \"gtable\" [label = \"gtable\"] \n  \"digest\" [label = \"digest\"] \n  \"pkgmaker\" [label = \"pkgmaker\"] \n  \"registry\" [label = \"registry\"] \n  \"rngtools\" [label = \"rngtools\"] \n  \"gridBase\" [label = \"gridBase\"] \n  \"colorspace\" [label = \"colorspace\"] \n  \"foreach\" [label = \"foreach\"] \n  \"doParallel\" [label = \"doParallel\"] \n  \"ggplot2\" [label = \"ggplot2\"] \n  \"reshape2\" [label = \"reshape2\"] \n  \"htmltools\" [label = \"htmltools\"] \n  \"jsonlite\" [label = \"jsonlite\"] \n  \"yaml\" [label = \"yaml\"] \n  \"magrittr\" [label = \"magrittr\"] \n  \"NMF\" [label = \"NMF\"] \n  \"irlba\" [label = \"irlba\"] \n  \"stringi\" [label = \"stringi\"] \n  \"RColorBrewer\" [label = \"RColorBrewer\"] \n  \"dichromat\" [label = \"dichromat\"] \n  \"plyr\" [label = \"plyr\"] \n  \"munsell\" [label = \"munsell\"] \n  \"labeling\" [label = \"labeling\"] \n  \"Rcpp\" [label = \"Rcpp\"] \n  \"htmlwidgets\" [label = \"htmlwidgets\"] \n  \"igraph\" [label = \"igraph\"] \n  \"influenceR\" [label = \"influenceR\"] \n  \"rstudioapi\" [label = \"rstudioapi\"] \n  \"stringr\" [label = \"stringr\"] \n  \"visNetwork\" [label = \"visNetwork\"] \n  \"scales\" [label = \"scales\"] \n  \"DiagrammeR\" [label = \"DiagrammeR\", fillcolor = \"blue\"] \n\"colorspace\"->\"graphics\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"foreach\"->\"codetools\" [color = \"DarkRed\"] \n\"ggplot2\"->\"digest\" [color = \"DarkRed\"] \n\"gridBase\"->\"graphics\" [color = \"DarkRed\"] \n\"gtable\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"utils\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"htmltools\" [color = \"DarkRed\"] \n\"igraph\"->\"Matrix\" [color = \"DarkRed\"] \n\"influenceR\"->\"igraph\" [color = \"DarkRed\"] \n\"irlba\"->\"stats\" [color = \"DarkRed\"] \n\"munsell\"->\"colorspace\" [color = \"DarkRed\"] \n\"NMF\"->\"graphics\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"methods\" [color = \"DarkRed\"] \n\"plyr\"->\"Rcpp\" [color = \"DarkRed\"] \n\"Rcpp\"->\"methods\" [color = \"DarkRed\"] \n\"registry\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"plyr\" [color = \"DarkRed\"] \n\"rngtools\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"stringi\"->\"tools\" [color = \"DarkRed\"] \n\"stringr\"->\"stringi\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"xtable\"->\"stats\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"igraph\" [color = \"DarkRed\"] \n\"foreach\"->\"utils\" [color = \"DarkRed\"] \n\"ggplot2\"->\"grid\" [color = \"DarkRed\"] \n\"gridBase\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"digest\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"jsonlite\" [color = \"DarkRed\"] \n\"igraph\"->\"magrittr\" [color = \"DarkRed\"] \n\"influenceR\"->\"Matrix\" [color = \"DarkRed\"] \n\"irlba\"->\"methods\" [color = \"DarkRed\"] \n\"munsell\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stats\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"tools\" [color = \"DarkRed\"] \n\"Rcpp\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"stringr\" [color = \"DarkRed\"] \n\"rngtools\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"dichromat\" [color = \"DarkRed\"] \n\"stringi\"->\"utils\" [color = \"DarkRed\"] \n\"stringr\"->\"magrittr\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmltools\" [color = \"DarkRed\"] \n\"xtable\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"influenceR\" [color = \"DarkRed\"] \n\"foreach\"->\"iterators\" [color = \"DarkRed\"] \n\"ggplot2\"->\"gtable\" [color = \"DarkRed\"] \n\"htmltools\"->\"Rcpp\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"yaml\" [color = \"DarkRed\"] \n\"igraph\"->\"NMF\" [color = \"DarkRed\"] \n\"influenceR\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stringr\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"codetools\" [color = \"DarkRed\"] \n\"reshape2\"->\"Rcpp\" [color = \"DarkRed\"] \n\"scales\"->\"plyr\" [color = \"DarkRed\"] \n\"stringi\"->\"stats\" [color = \"DarkRed\"] \n\"visNetwork\"->\"jsonlite\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"rstudioapi\" [color = \"DarkRed\"] \n\"ggplot2\"->\"MASS\" [color = \"DarkRed\"] \n\"igraph\"->\"irlba\" [color = \"DarkRed\"] \n\"influenceR\"->\"utils\" [color = \"DarkRed\"] \n\"NMF\"->\"digest\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"munsell\" [color = \"DarkRed\"] \n\"visNetwork\"->\"magrittr\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"stringr\" [color = \"DarkRed\"] \n\"ggplot2\"->\"plyr\" [color = \"DarkRed\"] \n\"NMF\"->\"grid\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"labeling,\" [color = \"DarkRed\"] \n\"visNetwork\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"visNetwork\" [color = \"DarkRed\"] \n\"ggplot2\"->\"scales\" [color = \"DarkRed\"] \n\"NMF\"->\"grDevices,\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"xtable\" [color = \"DarkRed\"] \n\"scales\"->\"Rcpp\" [color = \"DarkRed\"] \n\"visNetwork\"->\"methods\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"scales\" [color = \"DarkRed\"] \n\"ggplot2\"->\"stats\" [color = \"DarkRed\"] \n\"NMF\"->\"colorspace\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"grDevices\" [color = \"DarkRed\"] \n\"NMF\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"NMF\"->\"foreach\" [color = \"DarkRed\"] \n\"NMF\"->\"doParallel,\" [color = \"DarkRed\"] \n\"NMF\"->\"reshape2\" [color = \"DarkRed\"] \n\"colorspace\"->\"R\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"R\" [color = \"DarkSlateBlue\"] \n\"digest\"->\"R\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"R\" [color = \"DarkSlateBlue\"] \n\"foreach\"->\"R\" [color = \"DarkSlateBlue\"] \n\"ggplot2\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gridBase\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"htmltools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"igraph\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"influenceR\"->\"R\" [color = \"DarkSlateBlue\"] \n\"irlba\"->\"Matrix\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"R\" [color = \"DarkSlateBlue\"] \n\"jsonlite\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"R\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"R\" [color = \"DarkSlateBlue\"] \n\"plyr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"RColorBrewer\"->\"R\" [color = \"DarkSlateBlue\"] \n\"Rcpp\"->\"R\" [color = \"DarkSlateBlue\"] \n\"registry\"->\"R\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"scales\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringi\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"visNetwork\"->\"R\" [color = \"DarkSlateBlue\"] \n\"xtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"colorspace\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"foreach(>=\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"iterators(>=\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"registry\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"registry,\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"cluster\" [color = \"DarkSlateBlue\"] \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
circo Layout
------------

``` r
graph_DiagrammeR<-DiagrammeR::set_global_graph_attrs(graph_DiagrammeR,"graph","layout","circo")
DiagrammeR::render_graph(graph_DiagrammeR,output="graph")
```

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-50a077af16a11853b10a">{"x":{"diagram":"digraph {\n\ngraph [layout = dot,\n       overlap=FALSE,\n       layout = twopi,\n       layout = neato,\n       layout = circo]\n\nnode [fontname = Helvetica]\n\n  \"xtable\" [label = \"xtable\"] \n  \"iterators\" [label = \"iterators\"] \n  \"gtable\" [label = \"gtable\"] \n  \"digest\" [label = \"digest\"] \n  \"pkgmaker\" [label = \"pkgmaker\"] \n  \"registry\" [label = \"registry\"] \n  \"rngtools\" [label = \"rngtools\"] \n  \"gridBase\" [label = \"gridBase\"] \n  \"colorspace\" [label = \"colorspace\"] \n  \"foreach\" [label = \"foreach\"] \n  \"doParallel\" [label = \"doParallel\"] \n  \"ggplot2\" [label = \"ggplot2\"] \n  \"reshape2\" [label = \"reshape2\"] \n  \"htmltools\" [label = \"htmltools\"] \n  \"jsonlite\" [label = \"jsonlite\"] \n  \"yaml\" [label = \"yaml\"] \n  \"magrittr\" [label = \"magrittr\"] \n  \"NMF\" [label = \"NMF\"] \n  \"irlba\" [label = \"irlba\"] \n  \"stringi\" [label = \"stringi\"] \n  \"RColorBrewer\" [label = \"RColorBrewer\"] \n  \"dichromat\" [label = \"dichromat\"] \n  \"plyr\" [label = \"plyr\"] \n  \"munsell\" [label = \"munsell\"] \n  \"labeling\" [label = \"labeling\"] \n  \"Rcpp\" [label = \"Rcpp\"] \n  \"htmlwidgets\" [label = \"htmlwidgets\"] \n  \"igraph\" [label = \"igraph\"] \n  \"influenceR\" [label = \"influenceR\"] \n  \"rstudioapi\" [label = \"rstudioapi\"] \n  \"stringr\" [label = \"stringr\"] \n  \"visNetwork\" [label = \"visNetwork\"] \n  \"scales\" [label = \"scales\"] \n  \"DiagrammeR\" [label = \"DiagrammeR\", fillcolor = \"blue\"] \n\"colorspace\"->\"graphics\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"foreach\"->\"codetools\" [color = \"DarkRed\"] \n\"ggplot2\"->\"digest\" [color = \"DarkRed\"] \n\"gridBase\"->\"graphics\" [color = \"DarkRed\"] \n\"gtable\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"utils\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"htmltools\" [color = \"DarkRed\"] \n\"igraph\"->\"Matrix\" [color = \"DarkRed\"] \n\"influenceR\"->\"igraph\" [color = \"DarkRed\"] \n\"irlba\"->\"stats\" [color = \"DarkRed\"] \n\"munsell\"->\"colorspace\" [color = \"DarkRed\"] \n\"NMF\"->\"graphics\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"methods\" [color = \"DarkRed\"] \n\"plyr\"->\"Rcpp\" [color = \"DarkRed\"] \n\"Rcpp\"->\"methods\" [color = \"DarkRed\"] \n\"registry\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"plyr\" [color = \"DarkRed\"] \n\"rngtools\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"stringi\"->\"tools\" [color = \"DarkRed\"] \n\"stringr\"->\"stringi\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmlwidgets\" [color = \"DarkRed\"] \n\"xtable\"->\"stats\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"igraph\" [color = \"DarkRed\"] \n\"foreach\"->\"utils\" [color = \"DarkRed\"] \n\"ggplot2\"->\"grid\" [color = \"DarkRed\"] \n\"gridBase\"->\"grid\" [color = \"DarkRed\"] \n\"htmltools\"->\"digest\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"jsonlite\" [color = \"DarkRed\"] \n\"igraph\"->\"magrittr\" [color = \"DarkRed\"] \n\"influenceR\"->\"Matrix\" [color = \"DarkRed\"] \n\"irlba\"->\"methods\" [color = \"DarkRed\"] \n\"munsell\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stats\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"tools\" [color = \"DarkRed\"] \n\"Rcpp\"->\"utils\" [color = \"DarkRed\"] \n\"reshape2\"->\"stringr\" [color = \"DarkRed\"] \n\"rngtools\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"dichromat\" [color = \"DarkRed\"] \n\"stringi\"->\"utils\" [color = \"DarkRed\"] \n\"stringr\"->\"magrittr\" [color = \"DarkRed\"] \n\"visNetwork\"->\"htmltools\" [color = \"DarkRed\"] \n\"xtable\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"influenceR\" [color = \"DarkRed\"] \n\"foreach\"->\"iterators\" [color = \"DarkRed\"] \n\"ggplot2\"->\"gtable\" [color = \"DarkRed\"] \n\"htmltools\"->\"Rcpp\" [color = \"DarkRed\"] \n\"htmlwidgets\"->\"yaml\" [color = \"DarkRed\"] \n\"igraph\"->\"NMF\" [color = \"DarkRed\"] \n\"influenceR\"->\"methods\" [color = \"DarkRed\"] \n\"NMF\"->\"stringr\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"codetools\" [color = \"DarkRed\"] \n\"reshape2\"->\"Rcpp\" [color = \"DarkRed\"] \n\"scales\"->\"plyr\" [color = \"DarkRed\"] \n\"stringi\"->\"stats\" [color = \"DarkRed\"] \n\"visNetwork\"->\"jsonlite\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"rstudioapi\" [color = \"DarkRed\"] \n\"ggplot2\"->\"MASS\" [color = \"DarkRed\"] \n\"igraph\"->\"irlba\" [color = \"DarkRed\"] \n\"influenceR\"->\"utils\" [color = \"DarkRed\"] \n\"NMF\"->\"digest\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"digest\" [color = \"DarkRed\"] \n\"scales\"->\"munsell\" [color = \"DarkRed\"] \n\"visNetwork\"->\"magrittr\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"stringr\" [color = \"DarkRed\"] \n\"ggplot2\"->\"plyr\" [color = \"DarkRed\"] \n\"NMF\"->\"grid\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"stringr\" [color = \"DarkRed\"] \n\"scales\"->\"labeling,\" [color = \"DarkRed\"] \n\"visNetwork\"->\"utils\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"visNetwork\" [color = \"DarkRed\"] \n\"ggplot2\"->\"scales\" [color = \"DarkRed\"] \n\"NMF\"->\"grDevices,\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"xtable\" [color = \"DarkRed\"] \n\"scales\"->\"Rcpp\" [color = \"DarkRed\"] \n\"visNetwork\"->\"methods\" [color = \"DarkRed\"] \n\"DiagrammeR\"->\"scales\" [color = \"DarkRed\"] \n\"ggplot2\"->\"stats\" [color = \"DarkRed\"] \n\"NMF\"->\"colorspace\" [color = \"DarkRed\"] \n\"pkgmaker\"->\"grDevices\" [color = \"DarkRed\"] \n\"NMF\"->\"RColorBrewer\" [color = \"DarkRed\"] \n\"NMF\"->\"foreach\" [color = \"DarkRed\"] \n\"NMF\"->\"doParallel,\" [color = \"DarkRed\"] \n\"NMF\"->\"reshape2\" [color = \"DarkRed\"] \n\"colorspace\"->\"R\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"R\" [color = \"DarkSlateBlue\"] \n\"digest\"->\"R\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"R\" [color = \"DarkSlateBlue\"] \n\"foreach\"->\"R\" [color = \"DarkSlateBlue\"] \n\"ggplot2\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gridBase\"->\"R\" [color = \"DarkSlateBlue\"] \n\"gtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"htmltools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"igraph\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"influenceR\"->\"R\" [color = \"DarkSlateBlue\"] \n\"irlba\"->\"Matrix\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"R\" [color = \"DarkSlateBlue\"] \n\"jsonlite\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"R\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"R\" [color = \"DarkSlateBlue\"] \n\"plyr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"RColorBrewer\"->\"R\" [color = \"DarkSlateBlue\"] \n\"Rcpp\"->\"R\" [color = \"DarkSlateBlue\"] \n\"registry\"->\"R\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"R\" [color = \"DarkSlateBlue\"] \n\"scales\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringi\"->\"R\" [color = \"DarkSlateBlue\"] \n\"stringr\"->\"R\" [color = \"DarkSlateBlue\"] \n\"visNetwork\"->\"R\" [color = \"DarkSlateBlue\"] \n\"xtable\"->\"R\" [color = \"DarkSlateBlue\"] \n\"colorspace\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"dichromat\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"foreach(>=\" [color = \"DarkSlateBlue\"] \n\"iterators\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"stats\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"methods\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"iterators(>=\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"pkgmaker\"->\"registry\" [color = \"DarkSlateBlue\"] \n\"rngtools\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"doParallel\"->\"utils\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"pkgmaker\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"registry,\" [color = \"DarkSlateBlue\"] \n\"NMF\"->\"cluster\" [color = \"DarkSlateBlue\"] \n}","config":{"engine":null,"options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
########################### 

Conclusion
==========

Appraisal
---------

### Pros

-   DOT Language integration
-   Simple Design (EDFs, NDFs)
-   Visualisation Layout

### Cons

-   Query Performance

Session Info
------------

    ## R version 3.3.1 (2016-06-21)
    ## Platform: x86_64-pc-linux-gnu (64-bit)
    ## Running under: Debian GNU/Linux stretch/sid
    ## 
    ## locale:
    ##  [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
    ##  [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
    ##  [5] LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
    ##  [7] LC_PAPER=en_US.UTF-8       LC_NAME=C                 
    ##  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
    ## [11] LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] dplyr_0.5.0      magrittr_1.5     DiagrammeR_0.8.4
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] igraph_1.0.1     Rcpp_0.12.7      rstudioapi_0.6   knitr_1.14      
    ##  [5] munsell_0.4.3    colorspace_1.2-6 R6_2.1.3         stringr_1.1.0   
    ##  [9] plyr_1.8.4       tools_3.3.1      visNetwork_1.0.2 DBI_0.5-1       
    ## [13] influenceR_0.1.0 htmltools_0.3.5  lazyeval_0.2.0   yaml_2.1.13     
    ## [17] digest_0.6.10    assertthat_0.1   tibble_1.2       formatR_1.4     
    ## [21] htmlwidgets_0.7  evaluate_0.9     rmarkdown_1.0    stringi_1.1.1   
    ## [25] scales_0.4.0     jsonlite_1.1
