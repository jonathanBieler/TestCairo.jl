using TestCairo, Homebrew, Libdl

@info "installing cairo"
Homebrew.add("cairo")
#Homebrew.brew(`install cairo`)
@info "done installing cairo"

@show readdir( joinpath( Homebrew.prefix(), "Cellar/cairo/1.16.0/lib/") )

const _jl_libcairo = joinpath( Homebrew.prefix(), "Cellar/cairo/1.16.0/lib/","libcairo.dylib" )

@show h = Libdl.dlopen_e(_jl_libcairo, Libdl.RTLD_LAZY)
@show libcairo_version = VersionNumber(unsafe_string(ccall((:cairo_version_string,_jl_libcairo),Cstring,()) ))

