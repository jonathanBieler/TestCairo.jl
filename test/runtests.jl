using TestCairo, Homebrew, Libdl, Test

@info "installing cairo"
Homebrew.add("cairo")
#Homebrew.brew(`install cairo`)
@info "done installing cairo"

@show readdir( joinpath( Homebrew.prefix(), "Cellar/cairo/1.16.0/lib/") )

const _jl_libcairo = joinpath( Homebrew.prefix(), "Cellar/cairo/1.16.0/lib/","libcairo.dylib" )

@testset "opening dylib" begin
    for lib in ["libcairo-gobject.2.dylib", "libcairo-gobject.dylib", "libcairo-script-interpreter.2.dylib", "libcairo.2.dylib","libcairo.dylib"]
        l = joinpath( Homebrew.prefix(), "Cellar/cairo/1.16.0/lib/", lib )
        h = Libdl.dlopen_e(l, Libdl.RTLD_LAZY)
        @test h != C_NULL
    end
end

@testset "version" begin

    h = Libdl.dlopen_e(_jl_libcairo, Libdl.RTLD_LAZY)
    @test libcairo_version = VersionNumber(unsafe_string(ccall((:cairo_version_string,_jl_libcairo),Cstring,()) )) ==  v"1.16.0"

    f = Libdl.dlsym_e(h, "cairo_version")
    f == C_NULL && return false
    v = ccall(f, Int32,())
    @test v > 10800

end