# App Title ----
# Set the title for the app, displayed in top left corner
title = "Sacramento Open Data"

# GitHub Link ----
# Provide the link to the GitHub repo for the app
github_link = "https://github.com/mvanbommel/SacOpenData"

# Map Bounds ----
# Set the bounds for points that will be displayed on the map
# To show all points, regardless of location, use values:
#  - latitude_bounds = c(-90, 90)
#  - longitude_bounds = c(-180, 180)
latitude_bounds = c(37, 42)
longitude_bounds = c(-125, -118)

# Map Defaults ----
# Set the default latitude, longitude, and zoom values for the map
# Larger zoom values zoom in the map more
map_center_latitude = 38.55
map_center_longitude = -121.5
map_zoom = 11

# Dataset List ----
# Define the datasets available in the app. Each list entry should include:
# - name: name of the dataset, displayed in the Select Dataset dropdown
# - api: link to the API for the ArcGIS REST feature server layer of the dataset
# - url: link to an information page for the dataset, linked in data_source_button
dataset_list = list(
  list(name = "Bicycle Facilities - Existing",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Bike_Master_Plan_Facilities/FeatureServer/1",
       url = "https://data.cityofsacramento.org/datasets/15f8e048d9ad4442a3e12b6182bcd4f2_1"),
  list(name = "Bicycle Facilities - Planned",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Bike_Master_Plan_Facilities/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/15f8e048d9ad4442a3e12b6182bcd4f2_0"),
  list(name = "City Maintained Trees",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_Maintained_Trees/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/b9b716e09b5048179ab648bb4518452b_0"),
  list(name = "Council Districts",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Council_Districts/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/28bd505c8e674a49ba5f782d0d806033_0"),
  list(name = "Community Centers",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_of_Sacramento_Community_Centers/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/8c4aca76c2ed4eabb28daa18de11c837_0"),
  list(name = "Community Plan Areas",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Community_Plan_Areas/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/aba7ef895e7b45c28812d25753da7ebe_0"),
  list(name = "Dispatch Data From Current Year",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year3/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/9efe7653009b448f8d177c1da0cc068f_0"),
  list(name = "Dispatch Data From One Year Ago",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/cad_calls_year2/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/396e0bc72dcd4b038206f4a7239792bb_0"),
  list(name = "EV Chargers",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/EV_Chargers/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/93efdbcdbc744210848dd7f601e622e3_0"),
  list(name = "Fire Department 911 Call Response",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/GetNFIRSRespondReport/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0b32edde7b14480e82d0d746108431db_0"),
  list(name = "Fire Stations",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Fire_Stations/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/614bdde2a4714b2098d4c2532fd2c6e7_0"),
  list(name = "Historic Districts",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Historic_Districts/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/2c3e136e2e00435b9a875bb14d5aaf85_0"),
  list(name = "Historic Landmarks",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Historic_Landmarks/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/d24b5b9a87c74e2dbdc0862d758d4471_0"),
  list(name = "Historic Resources",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Historic_Resources/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/f10174d56aa442de93d67889caffbea7_0"),
  list(name = "Hospitals",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Hospitals/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0363364d7ddb4ff4aadd7057187a7a05_0"),
  list(name = "Low/Moderate Income Areas - Community Development Block Grants",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/CDBG_Low_Mod_Areas_2019/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/979b1fbded074a60b2c7b129a4a49349_0"),
  list(name = "Neighborhoods",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Neighborhoods/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/49f20f1612ae4f0a9292eb65f8bd4013_0"),
  list(name = "Neighborhood Associations",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Neighborhood_Associations/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/7ccbaa1f4ea6421a8e58b3e3efda7903_0"),
  list(name = "Off Street Parking",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/PublicAccessParkingMapService/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/1a75cd6cbadc4059990cd40620d81c56_0"),
  list(name = "On Street Parking",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/ONSTREETPARKING/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/0060469c57864becb76a036d23236143_0"),
  list(name = "Parks",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Parks/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/b3047674f3f04a759c484fe5208faf6c_0"),
  list(name = "Park Amenities",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Public_Park_Amenities/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/f0773d98f269411f8c19de132596ac3d_0"),
  list(name = "Park Public Restrooms",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Parks_Public_Restrooms/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/b9e7fa6d1d104833b3f04268d7f682dc_0"),
  list(name = "Police Beats",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/POLICE_BEATS/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/0d7615bf9b1e47948046a82b261d2384_0"),
  list(name = "Police Districts",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/POLICE_DISTRICTS/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/9699844616464dffa5a9da94f870307a_0"),
  list(name = "Police Grids",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/POLICE_GRIDS/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/8e736e55b2ae43a4b04dade9bb23774d_0"),
  list(name = "Schools",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Schools/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/fd3677bd8ff44a2cbe6b8cc67a3d2c1c_0"),
  list(name = "Signs",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Signs/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/669f377150b74ae4863b5eefbdde39b7_0"),
  list(name = "Street Lights",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Street_Lights/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/3dca1faa7e0a40f79f31f95c0b2ebd17_0"),
  list(name = "Streetcar Lines - Proposed",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Streetcar_Line/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/9199aea0c03f4e858fb4e01aeb9feb8c_0"),
  list(name = "Streetcar Stops - Proposed",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Streetcar_Stops/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/5922bb984d8748d1a457164d4416dced_0"),
  list(name = "Subdivisions",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Subdivisions/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/9cceb25741a04ffc83288beff6a444b4_0"),
  list(name = "Traffic Signals",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/City_of_Sacramento_Traffic_Signals/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/ad6ad4ec348e4302b2432ba9078ac1fd_0"),
  list(name = "Zoning",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/Zoning/FeatureServer/0",
       url = "https://data.cityofsacramento.org/datasets/13a456d86b0d47459a61e2dacfc8f609_0"),
  list(name = "311 Calls",
       api = "https://services5.arcgis.com/54falWtcpty3V47Z/arcgis/rest/services/311Calls_OSC_View/FeatureServer/0",
       url = "http://data.cityofsacramento.org/datasets/08794a6695b3483f889e9bef122517e9_0")
)
