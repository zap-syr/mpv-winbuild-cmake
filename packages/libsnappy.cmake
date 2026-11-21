# Snappy (BSD-3-Clause): FFmpeg's HAP encoder needs it (--enable-libsnappy).
# The HAP decoder does not, it uses FFmpeg's own snappy code.
# snappy adds -Werror for clang unless CMAKE_CXX_FLAGS already has it, so
# "-Werror -Wno-error" keeps cross-compile warnings from failing the build.
ExternalProject_Add(libsnappy
    GIT_REPOSITORY https://github.com/google/snappy.git
    SOURCE_DIR ${SOURCE_LOCATION}
    GIT_CLONE_FLAGS "--filter=tree:0"
    # A fixed release: no GIT_REMOTE_NAME, so force-update resets to it, not to @{u}.
    GIT_TAG 1.2.2
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ${EXEC} CONF=1 cmake -H<SOURCE_DIR> -B<BINARY_DIR>
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}
        -DCMAKE_INSTALL_PREFIX=${MINGW_INSTALL_PREFIX}
        -DCMAKE_FIND_ROOT_PATH=${MINGW_INSTALL_PREFIX}
        -DBUILD_SHARED_LIBS=OFF
        -DSNAPPY_BUILD_TESTS=OFF
        -DSNAPPY_BUILD_BENCHMARKS=OFF
        -DSNAPPY_INSTALL=ON
        # Single quotes: ${EXEC} runs the line through a shell, which would split it.
        -DCMAKE_CXX_FLAGS='-Werror -Wno-error'
    BUILD_COMMAND ${EXEC} ninja -C <BINARY_DIR>
    INSTALL_COMMAND ${EXEC} ninja -C <BINARY_DIR> install
    LOG_DOWNLOAD 1 LOG_UPDATE 1 LOG_CONFIGURE 1 LOG_BUILD 1 LOG_INSTALL 1
)

force_rebuild_git(libsnappy)
cleanup(libsnappy install)
