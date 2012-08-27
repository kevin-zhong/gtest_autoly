#include <gtest/gtest.h>

#ifndef _NO_GLOBAL_H
	#include "global_var.h"
#endif


struct UnitTestorApp
{
};

int main(int32_t argc, char **argv)
{
    testing::InitGoogleTest(&argc, (char**)argv);
    return RUN_ALL_TESTS();    
}


