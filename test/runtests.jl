using PkgCleanup
using Test

@testset "PkgCleanup.jl" begin
    @test isdir(PkgCleanup.logs_directory())
end
