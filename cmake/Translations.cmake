# Translations.cmake, CMake macros written for Marlin, feel free to re-use them

macro (add_translations_directory NLS_PACKAGE)
    add_custom_target (i18n ALL COMMENT “Building i18n messages.”)
    find_program (MSGFMT_EXECUTABLE msgfmt)
    # be sure that all languages are present
    # Using all usual languages code from https://www.gnu.org/software/gettext/manual/html_node/Language-Codes.html#Language-Codes
    # Rare language codes should be added on-demand.
    set (LANGUAGES_NEEDED aa ab ae af ak am an ar as ast av ay az ba be bg bh bi bm bn bo br bs ca ce ch ckb co cr cs cu cv cy da de dv dz ee el en_AU en_CA en_GB eo es et eu fa ff fi fj fo fr fr_CA fy ga gd gl gn gu gv ha he hi ho hr ht hu hy hz ia id ie ig ii ik io is it iu ja jv ka kg ki kj kk kl km kn ko kr ks ku kv kw ky la lb lg li ln lo lt lu lv mg mh mi mk ml mn mo mr ms mt my na nb nd ne ng nl nn no nr nv ny oc oj om or os pa pi pl ps pt pt_BR qu rm rn ro ru rue rw sa sc sd se sg si sk sl sm sma sn so sq sr ss st su sv sw ta te tg th ti tk tl tn to tr ts tt tw ty ug uk ur uz ve vi vo wa wo xh yi yo za zh zh_CN zh_HK zh_TW zu)
    foreach (LANGUAGE_NEEDED ${LANGUAGES_NEEDED})
        create_po_file (${LANGUAGE_NEEDED})
    endforeach (LANGUAGE_NEEDED ${LANGUAGES_NEEDED})
    # generate .mo from .po
    file (GLOB PO_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.po)
    foreach (PO_INPUT ${PO_FILES})
        get_filename_component (PO_INPUT_BASE ${PO_INPUT} NAME_WE)
        set (MO_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PO_INPUT_BASE}.mo)
        add_custom_command (TARGET i18n COMMAND ${MSGFMT_EXECUTABLE} -o ${MO_OUTPUT} ${PO_INPUT})

        install (FILES ${MO_OUTPUT} DESTINATION
            share/locale/${PO_INPUT_BASE}/LC_MESSAGES
            RENAME ${NLS_PACKAGE}.mo)
    endforeach (PO_INPUT ${PO_FILES})
endmacro (add_translations_directory)

# Apply the right default template.
macro (create_po_file LANGUAGE_NEEDED)
    set (FILE ${CMAKE_CURRENT_SOURCE_DIR}/${LANGUAGE_NEEDED}.po)
    if (NOT EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/${LANGUAGE_NEEDED}.po)
        file (APPEND ${FILE} "msgid \"\"\n")
        file (APPEND ${FILE} "msgstr \"\"\n")
        file (APPEND ${FILE} "\"MIME-Version: 1.0\\n\"\n")
        file (APPEND ${FILE} "\"Content-Type: text/plain; charset=UTF-8\\n\"\n")

        if ("${LANGUAGE_NEEDED}" STREQUAL "ja"
            OR "${LANGUAGE_NEEDED}" STREQUAL "vi"
            OR "${LANGUAGE_NEEDED}" STREQUAL "ko")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=2; plural=n == 1 ? 0 : 1;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "en"
            OR "${LANGUAGE_NEEDED}" STREQUAL "de"
            OR "${LANGUAGE_NEEDED}" STREQUAL "nl"
            OR "${LANGUAGE_NEEDED}" STREQUAL "sv"
            OR "${LANGUAGE_NEEDED}" STREQUAL "nb"
            OR "${LANGUAGE_NEEDED}" STREQUAL "nn"
            OR "${LANGUAGE_NEEDED}" STREQUAL "nb"
            OR "${LANGUAGE_NEEDED}" STREQUAL "no"
            OR "${LANGUAGE_NEEDED}" STREQUAL "fo"
            OR "${LANGUAGE_NEEDED}" STREQUAL "es"
            OR "${LANGUAGE_NEEDED}" STREQUAL "pt"
            OR "${LANGUAGE_NEEDED}" STREQUAL "it"
            OR "${LANGUAGE_NEEDED}" STREQUAL "bg"
            OR "${LANGUAGE_NEEDED}" STREQUAL "he"
            OR "${LANGUAGE_NEEDED}" STREQUAL "fi"
            OR "${LANGUAGE_NEEDED}" STREQUAL "et"
            OR "${LANGUAGE_NEEDED}" STREQUAL "eo"
            OR "${LANGUAGE_NEEDED}" STREQUAL "hu"
            OR "${LANGUAGE_NEEDED}" STREQUAL "tr"
            OR "${LANGUAGE_NEEDED}" STREQUAL "es")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=2; plural=n != 1;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "fr"
            OR "${LANGUAGE_NEEDED}" STREQUAL "fr_CA"
            OR "${LANGUAGE_NEEDED}" STREQUAL "pt_BR")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=2; plural=n>1;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "lv")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n != 0 ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "ro")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=n==1 ? 0 : (n==0 || (n%100 > 0 && n%100 < 20)) ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "lt")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n%10>=2 && (n%100<10 || n%100>=20) ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "ru"
            OR "${LANGUAGE_NEEDED}" STREQUAL "uk"
            OR "${LANGUAGE_NEEDED}" STREQUAL "be"
            OR "${LANGUAGE_NEEDED}" STREQUAL "sr"
            OR "${LANGUAGE_NEEDED}" STREQUAL "hr")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "cs"
            OR "${LANGUAGE_NEEDED}" STREQUAL "sk")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=(n==1) ? 0 : (n>=2 && n<=4) ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "pl")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=3; plural=n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2;\\n\"\n")
        elseif ("${LANGUAGE_NEEDED}" STREQUAL "sl")
                file (APPEND ${FILE} "\"Plural-Forms: nplurals=4; plural=n%100==1 ? 0 : n%100==2 ? 1 : n%100==3 || n%100==4 ? 2 : 3;\\n\"\n")
        endif ()

    endif ()
endmacro (create_po_file)

function(get_binary_folder_for_file BINARY_RESULT SOURCE)
    if(NOT DEFINED ${BINARY_RESULT})
      message (SEND_ERROR "Error, the variable ${BINARY_RESULT} is not defined!")
    endif()

    if (NOT ((${SOURCE} MATCHES ${CMAKE_SOURCE_DIR}) OR (${SOURCE} MATCHES ${CMAKE_BINARY_DIR})))
        set (SOURCE ${CMAKE_CURRENT_SOURCE_DIR}/${SOURCE})
    endif()

    get_filename_component (SOURCE ${SOURCE} ABSOLUTE)
    if (NOT(${SOURCE} MATCHES ${CMAKE_BINARY_DIR}))
        string (REPLACE ${CMAKE_SOURCE_DIR} ${CMAKE_BINARY_DIR} SOURCE ${SOURCE})
    endif()
    set (${BINARY_RESULT} ${SOURCE} PARENT_SCOPE)
endfunction()


macro (add_translations_catalog NLS_PACKAGE)
    parse_arguments(ARGS "DESKTOP_FILES;APPDATA_FILES;SCHEMA_FILES" "" ${ARGN})
    add_custom_target (pot COMMENT “Building translation catalog.”)
    find_program (XGETTEXT_EXECUTABLE xgettext)
    find_program (INTLTOOL_MERGE_EXECUTABLE intltool-merge)

    set(EXTRA_PO_DIR ${CMAKE_CURRENT_SOURCE_DIR}/extra/)

    set(C_SOURCE "")
    set(VALA_SOURCE "")
    set(GLADE_SOURCE "")

    set(APPDATA_SOURCE "")
    set(DESKTOP_SOURCE "")
    set(GSETTINGS_SOURCE "")

    foreach(FILES_INPUT ${ARGN})
        if((${FILES_INPUT} MATCHES ${CMAKE_SOURCE_DIR}) OR (${FILES_INPUT} MATCHES ${CMAKE_BINARY_DIR}))
            set(BASE_DIRECTORY ${FILES_INPUT})
        else ()
            set(BASE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/${FILES_INPUT})
        endif ()

        file (GLOB_RECURSE SOURCE_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/ ${BASE_DIRECTORY}/*.c)
        foreach(C_FILE ${SOURCE_FILES})
            set(C_SOURCE ${C_SOURCE} ${C_FILE})
        endforeach()

        file (GLOB_RECURSE SOURCE_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/ ${BASE_DIRECTORY}/*.vala)
        foreach(VALA_FILE ${SOURCE_FILES})
            set(VALA_SOURCE ${VALA_SOURCE} ${VALA_FILE})
        endforeach()

        file (GLOB_RECURSE SOURCE_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/ ${BASE_DIRECTORY}/*.ui)
        foreach(GLADE_FILE ${SOURCE_FILES})
            set(GLADE_SOURCE ${GLADE_SOURCE} ${GLADE_FILE})
        endforeach()
    endforeach()

    foreach (DESKTOP_FILE ${ARGS_DESKTOP_FILES})
        set(DESKTOP_SOURCE ${DESKTOP_SOURCE} ${DESKTOP_FILE})
        string(REGEX REPLACE "([^ ]*).in" "\\1" DESKTOP_FILE_OUT ${DESKTOP_FILE})
        get_binary_folder_for_file (DESKTOP_FILE_OUT ${DESKTOP_FILE_OUT})
        # Intltool can't create a new directory.
        get_filename_component(DESKTOP_FILE_OUT_DIRECTORY ${DESKTOP_FILE_OUT} DIRECTORY)
        file(MAKE_DIRECTORY ${DESKTOP_FILE_OUT_DIRECTORY})
        execute_process(WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${INTLTOOL_MERGE_EXECUTABLE} --quiet --desktop-style ${EXTRA_PO_DIR} ${DESKTOP_FILE} ${DESKTOP_FILE_OUT})
    endforeach (DESKTOP_FILE ${ARGS_DESKTOP_FILES})

    foreach (APPDATA_FILE ${ARGS_APPDATA_FILES})
        set(APPDATA_SOURCE ${APPDATA_SOURCE} ${APPDATA_FILE})
        string(REGEX REPLACE "([^ ]*).in" "\\1" APPDATA_FILE_OUT ${APPDATA_FILE})
        get_binary_folder_for_file (APPDATA_FILE_OUT ${APPDATA_FILE_OUT})
        # Intltool can't create a new directory.
        get_filename_component(APPDATA_FILE_OUT_DIRECTORY ${APPDATA_FILE_OUT} DIRECTORY)
        file(MAKE_DIRECTORY ${APPDATA_FILE_OUT_DIRECTORY})
        execute_process(WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${INTLTOOL_MERGE_EXECUTABLE} --quiet --xml-style ${EXTRA_PO_DIR} ${APPDATA_FILE} ${APPDATA_FILE_OUT})
    endforeach (APPDATA_FILE ${ARGS_APPDATA_FILES})

    foreach (GSETTINGS_FILE ${ARGS_SCHEMA_FILES})
        set(GSETTINGS_SOURCE ${GSETTINGS_SOURCE} ${GSETTINGS_FILE})
        string(REGEX REPLACE "([^ ]*).in" "\\1" GSETTINGS_FILE_OUT ${GSETTINGS_FILE})
        get_binary_folder_for_file (GSETTINGS_FILE_OUT ${GSETTINGS_FILE_OUT})
        # Intltool can't create a new directory.
        get_filename_component(GSETTINGS_FILE_OUT_DIRECTORY ${GSETTINGS_FILE_OUT} DIRECTORY)
        file(MAKE_DIRECTORY ${GSETTINGS_FILE_OUT_DIRECTORY})
        execute_process(WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${INTLTOOL_MERGE_EXECUTABLE} --quiet --schemas-style ${EXTRA_PO_DIR} ${GSETTINGS_FILE} ${GSETTINGS_FILE_OUT} OUTPUT_VARIABLE GSETTINGS_FINE)
        # We need to do this here otherwise there are some racing error.
        if (NOT (GSETTINGS_FINE))
            include (GSettings)
            add_schema (${GSETTINGS_FILE_OUT})
        endif (NOT (GSETTINGS_FINE))
    endforeach (GSETTINGS_FILE ${ARGS_SCHEMA_FILES})

    set(BASE_XGETTEXT_COMMAND
        ${XGETTEXT_EXECUTABLE} -d ${NLS_PACKAGE}
        -o ${CMAKE_CURRENT_SOURCE_DIR}/${NLS_PACKAGE}.pot
        --add-comments="/" --keyword="_" --keyword="N_" --keyword="C_:1c,2" --keyword="NC_:1c,2" --keyword="ngettext:1,2" --keyword="Q_:1g" --from-code=UTF-8)

    set(EXTRA_XGETTEXT_COMMAND
        ${XGETTEXT_EXECUTABLE} -d extra
        -o ${EXTRA_PO_DIR}/extra.pot
        --add-comments="/" --keyword="_" --keyword="N_" --keyword="C_:1c,2" --keyword="NC_:1c,2" --keyword="ngettext:1,2" --keyword="Q_:1g" --from-code=UTF-8)

    set(CONTINUE_FLAG "")

    IF(NOT "${C_SOURCE}" STREQUAL "")
        add_custom_command(TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${BASE_XGETTEXT_COMMAND} ${C_SOURCE})
        set(CONTINUE_FLAG "-j")
    ENDIF()

    IF(NOT "${VALA_SOURCE}" STREQUAL "")
        add_custom_command(TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${BASE_XGETTEXT_COMMAND} ${CONTINUE_FLAG} -LC\# ${VALA_SOURCE})
        set(CONTINUE_FLAG "-j")
    ENDIF()

    IF(NOT "${GLADE_SOURCE}" STREQUAL "")
        add_custom_command (TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${BASE_XGETTEXT_COMMAND} ${CONTINUE_FLAG} -LGlade ${GLADE_SOURCE})
    ENDIF()

    # We need to create the directory if one extra content exists.
    IF((NOT "${APPDATA_SOURCE}" STREQUAL "") OR (NOT "${DESKTOP_SOURCE}" STREQUAL "") OR (NOT "${GSETTINGS_SOURCE}" STREQUAL ""))
        file(MAKE_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/extra/)
    ENDIF()

    set(CONTINUE_FLAG "")

    IF(NOT "${DESKTOP_SOURCE}" STREQUAL "")
        add_custom_command(TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${EXTRA_XGETTEXT_COMMAND} -LDesktop ${DESKTOP_SOURCE})
        set(CONTINUE_FLAG "-j")
    ENDIF()

    IF(NOT "${APPDATA_SOURCE}" STREQUAL "")
        #add_custom_command(TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${EXTRA_XGETTEXT_COMMAND} ${CONTINUE_FLAG} -LAppData ${APPDATA_SOURCE})
        #set(CONTINUE_FLAG "-j")
    ENDIF()

    IF(NOT "${GSETTINGS_SOURCE}" STREQUAL "")
        add_custom_command(TARGET pot WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} COMMAND ${EXTRA_XGETTEXT_COMMAND} ${CONTINUE_FLAG} -LGSettings ${GSETTINGS_SOURCE})
    ENDIF()
endmacro ()
