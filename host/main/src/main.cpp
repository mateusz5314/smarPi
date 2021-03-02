#include <iostream>
#include <unistd.h>

int main(int argc, char **argv)
{
    while (1)
    {
        static int i = 0;
        std::cout << "Sleeping" << (i == 0 ? "." : i == 1 ? ".." : "...") << std::endl;
        if (++i > 2)
        {
            i = 0;
        }
        sleep(1);
    }

    return 0;
}