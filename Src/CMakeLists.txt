# PS> Get-ChildItem -Recurse | Resolve-Path -Relative > out.txt
add_executable(scpcb
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/angelscript/sdk/add_on/scriptarray/scriptarray.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/tinyxml2/tinyxml2.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/../Engine/Src/Init/Init.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/Collider.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/Collider.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/Collision.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/Collision.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/CollisionMesh.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/CollisionMesh.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/CollisionMeshCollection.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Collision/CollisionMeshCollection.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Billboard.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Billboard.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Camera.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Camera.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/DebugGraphics.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/DebugGraphics.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Font.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/Font.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/GraphicsResources.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/GraphicsResources.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/ModelImageGenerator.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/ModelImageGenerator.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/UIMesh.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Graphics/UIMesh.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/Input.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/Input.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/KeyBinds.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/KeyBinds.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/MouseData.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Input/MouseData.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/CBR.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/CBR.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/Model.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/Model.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/RM2.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Models/RM2.h
    ${CMAKE_CURRENT_SOURCE_DIR}/PlayerController/PlayerController.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/PlayerController/PlayerController.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Save/Config.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Save/Config.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Save/ConfigValues.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Save/ConfigValues.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/CachedArgument.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/CachedArgument.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinition.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinition.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/RefCounter.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/RefCounter.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/Script.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/Script.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptClass.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptClass.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptFunction.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptFunction.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptGlobal.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptGlobal.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptManager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptManager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptModule.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptModule.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptObject.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/ScriptObject.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/StringFactory.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/StringFactory.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/Type.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/Type.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/BillboardDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/BillboardDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/CollisionDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/CollisionDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ColorDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ColorDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ConsoleDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ConsoleDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/EventDefinition.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/EventDefinition.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/InputDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/InputDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/LocalizationDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/LocalizationDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/MathDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/MathDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/MementoDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/MementoDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ModelDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ModelDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ModelImageGeneratorDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ModelImageGeneratorDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/PickableDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/PickableDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/PlayerControllerDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/PlayerControllerDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/RandomDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/RandomDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ReflectionDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/ReflectionDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/RM2Definitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/RM2Definitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/TextureDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/TextureDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/UIDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/UIDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/WorldDefinitions.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Scripting/NativeDefinitions/WorldDefinitions.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/IntProperty.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/IntProperty.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/ScriptSerializer.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/ScriptSerializer.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/XMLProperty.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Serialize/XMLProperty.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/INI.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/INI.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/LocalizationManager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/LocalizationManager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/ResourcePackManager.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/ResourcePackManager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/TextureUtil.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/Utils/TextureUtil.h
    ${CMAKE_CURRENT_SOURCE_DIR}/World/DataInterpolator.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/World/DataInterpolator.h
    ${CMAKE_CURRENT_SOURCE_DIR}/World/Pickable.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/World/Pickable.h
    ${CMAKE_CURRENT_SOURCE_DIR}/World/ScriptWorld.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/World/ScriptWorld.h
    ${CMAKE_CURRENT_SOURCE_DIR}/World/Timing.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/World/Timing.h
    # ${CMAKE_CURRENT_SOURCE_DIR}/World/VRManager.cpp
    # ${CMAKE_CURRENT_SOURCE_DIR}/World/VRManager.h
    ${CMAKE_CURRENT_SOURCE_DIR}/World/World.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/World/World.h
    )

add_compile_definitions(STB_IMAGE_IMPLEMENTATION STBI_WINDOWS_UTF8 STBI_FAILURE_USERMSG) # stb_image
add_compile_definitions(SDL_MAIN_HANDLED)

target_compile_definitions(scpcb PUBLIC "$<$<CONFIG:DEBUG>:DEBUG>")

target_link_libraries(scpcb PUBLIC
    ${SDL2_LIBRARIES}
    Engine
    assimp
    freetype
    angelscript
    )

target_include_directories(scpcb PUBLIC
    ${SDL2_INCLUDE_DIRS}
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/angelscript/sdk/angelscript/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/angelscript/sdk/add_on
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/freetype/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/stb_image
    ${CMAKE_CURRENT_SOURCE_DIR}/../Libraries/tinyxml2
    )

add_custom_command(TARGET scpcb POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:scpcb> $<TARGET_FILE_DIR:scpcb>
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/../Content $<TARGET_FILE_DIR:scpcb>
    COMMAND_EXPAND_LISTS
    )

add_dependencies(scpcb BuildShaders)
add_custom_command(TARGET scpcb POST_BUILD
    COMMAND $<TARGET_FILE:BuildShaders> $<TARGET_FILE_DIR:scpcb>
    COMMAND_EXPAND_LISTS
    )
