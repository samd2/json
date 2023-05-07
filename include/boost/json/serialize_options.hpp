//
// Copyright (c) 2023 Dmitry Arkhipov (grisumbras@yandex.ru)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//
// Official repository: https://github.com/boostorg/json
//

#ifndef BOOST_JSON_SERIALIZE_OPTIONS_HPP
#define BOOST_JSON_SERIALIZE_OPTIONS_HPP

#include <boost/json/detail/config.hpp>

namespace boost {
namespace json {

/** Serialize options

    This structure is used for specifying whether to allow non-standard
    extensions. Default-constructed options specify that only standard JSON is
    produced.

    @see
        @ref serialize,
        @ref serializer.
*/
struct serialize_options
{
    /** Non-standard extension option

        Output `Infinity`, `-Infinity` and `NaN` for positive infinity,
        negative infinity, and "not a number" doubles.

        @see
            @ref serialize,
            @ref serializer.
    */
    bool allow_infinity_and_nan = false;
};

} // namespace json
} // namespace boost

#endif // BOOST_JSON_SERIALIZE_OPTIONS_HPP
