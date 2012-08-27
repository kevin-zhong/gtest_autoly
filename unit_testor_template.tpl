#include <gtest/gtest.h>
#include "common/application_basic.h"



class UnitTestorApp : public ApplicationNoSedaSvr
{
public:
    UnitTestorApp() : ApplicationNoSedaSvr("unit_testor")
    {
    }
    virtual ~UnitTestorApp(){}

    virtual int initializing()
    {
        testing::InitGoogleTest(&_argc, (char**)_argv);
        return RUN_ALL_TESTS();
    };
};

IMPLEMENT_APPLICATION(UnitTestorApp)



