
set(SOFTWARE "$ENV{SOFTWARE}")
if("${SOFTWARE}" STREQUAL "")
    set(SOFTWARE geant4)
endif()

configure_file(/tmp/${SOFTWARE}-config.cmake.in /tmp/${SOFTWARE}-build/${SOFTWARE}-config.cmake @ONLY)
