emcc -v src/novadraw_bindings.cpp -s EXPORTED_FUNCTIONS='["_draw"]' -s MODULARIZE=1 -s EXPORT_NAME='NovaDrawInit' -o nova_draw.js
