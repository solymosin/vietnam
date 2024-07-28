Plugin Builder Results

Your plugin VietVetVect was created in:
    /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect

Your QGIS plugin directory is located at:
    /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins

What's Next:

  * Copy the entire directory containing your new plugin to the QGIS plugin
    directory
    cp -r /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins
    

  * Compile the resources file using pyrcc5
  cd /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins/viet_vet_vect
  pyrcc5 resources.qrc

  * Run the tests (``make test``)
make test

  * Test the plugin by enabling it in the QGIS plugin manager

  * Customize it by editing the implementation file: ``viet_vet_vect.py``

  * Create your own custom icon, replacing the default icon.png

  * Modify your user interface by opening VietVetVect_dialog_base.ui in Qt Designer

  * You can use the Makefile to compile your Ui and resource files when
    you make changes. This requires GNU make (gmake)

For more information, see the PyQGIS Developer Cookbook at:
http://www.qgis.org/pyqgis-cookbook/index.html

(C) 2011-2018 GeoApt LLC - geoapt.com

cd /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect
pyrcc5 resources.qrc

cp -r /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins
cd /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins/viet_vet_vect
pyrcc5 resources.qrc

cd /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect
pb_tool compile
cp -r /home/sn/dev/aote/Para/Vietnam/vietnam_github/viet_vet_vect /home/sn/.local/share/QGIS/QGIS3/profiles/default/python/plugins

