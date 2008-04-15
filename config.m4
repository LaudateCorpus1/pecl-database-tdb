dnl $Id$

PHP_ARG_WITH(tdb, for Trivial DB support,
[  --with-tdb             Include Trivial DB support])

if test "$PHP_TDB" != "no"; then

  SEARCH_PATH="/usr/local/ /usr/"
  SEARCH_FOR="include/tdb.h"
  if test "$PHP_TDB" = "yes"; then
    AC_MSG_CHECKING([for Trivial DB files in default path])
    for i in $SEARCH_PATH ; do
      if test -r $i/$SEARCH_FOR; then
        TDB_DIR=$i
        AC_MSG_RESULT(found in $i)
      fi
    done
  elif test -r $PHP_TDB/$SEARCH_FOR; then
    AC_MSG_CHECKING([for Trivial DB files in $PHP_TDB])
    TDB_DIR=$PHP_TDB
  fi

  if test -z "$TDB_DIR"; then
    AC_MSG_RESULT([not found])
    AC_MSG_ERROR([Could not find Trivial DB headers])
  fi
  
  AC_MSG_RESULT([found])

  PHP_ADD_INCLUDE($TDB_DIR/include)

  LIBNAME=tdb
  LIBSYMBOL=tdb_open

  PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  [
    PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $TDB_DIR/lib, TDB_SHARED_LIBADD)
    AC_DEFINE(HAVE_TDBLIB,1,[ ])
  ],[
    AC_MSG_ERROR([wrong Trivial DB lib version or lib not found])
  ],[
    -L$TDB_DIR/lib -lm
  ])

  if test "$enable_experimental_zts" = "yes"; then
    AC_MSG_ERROR([Trivial DB is not thread safe])
  fi

  AC_DEFINE(HAVE_TDB,1,[ ])
  PHP_SUBST(TDB_SHARED_LIBADD)

  PHP_NEW_EXTENSION(tdb, tdb.c, $ext_shared)
fi
