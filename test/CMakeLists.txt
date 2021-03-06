#
# Copyright (c) 2019 Vinnie Falco (vinnie.falco@gmail.com)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#
# Official repository: https://github.com/boostorg/json
#

file(GLOB_RECURSE BOOST_JSON_TESTS_FILES CONFIGURE_DEPENDS Jamfile *.cpp *.hpp)
list(FILTER BOOST_JSON_TESTS_FILES EXCLUDE REGEX "^${CMAKE_CURRENT_SOURCE_DIR}/cmake_install_test/.*$")
if(BOOST_JSON_STANDALONE)
    list(FILTER BOOST_JSON_TESTS_FILES EXCLUDE REGEX "standalone_with_boost.cpp")
endif()

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "" FILES ${BOOST_JSON_TESTS_FILES})
add_executable(boost_json-tests ${BOOST_JSON_TESTS_FILES})
target_include_directories(boost_json-tests PRIVATE .)
target_link_libraries(boost_json-tests PRIVATE Boost::json)
add_test(NAME boost_json-tests COMMAND boost_json-tests)

source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR} PREFIX "" FILES limits.cpp main.cpp)
source_group(TREE ${CMAKE_CURRENT_SOURCE_DIR}/../src PREFIX "" FILES ../src/src.cpp)
add_executable(boost_json-limits limits.cpp main.cpp ../src/src.cpp Jamfile)

target_compile_features(boost_json-limits PUBLIC cxx_constexpr)

target_include_directories(boost_json-limits PRIVATE ../include .)
target_compile_definitions(boost_json-limits PRIVATE
    BOOST_JSON_MAX_STRING_SIZE=1000
    BOOST_JSON_MAX_STRUCTURED_SIZE=20
    BOOST_JSON_STACK_BUFFER_SIZE=256
    BOOST_JSON_NO_LIB=1
)

if(BOOST_JSON_STANDALONE)
    target_compile_definitions(boost_json-limits PRIVATE BOOST_JSON_STANDALONE)
    target_compile_features(boost_json-limits PRIVATE cxx_std_17)
elseif(BOOST_SUPERPROJECT_VERSION)
    target_link_libraries(boost_json-limits
        PRIVATE
            Boost::align
            Boost::assert
            Boost::config
            Boost::container
            Boost::exception
            Boost::mp11
            Boost::system
            Boost::throw_exception
            Boost::utility
    )
elseif(BOOST_JSON_IN_BOOST_TREE)
    target_include_directories(boost_json-limits PRIVATE ${BOOST_ROOT})
    target_link_directories(boost_json-limits PRIVATE ${BOOST_ROOT}/stage/lib)
else()
    target_link_libraries(boost_json-limits
        PRIVATE
            Boost::system
            Boost::container
    )
endif()

add_test(NAME boost_json-limits COMMAND boost_json-limits)
