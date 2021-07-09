using Documenter, AbstractAlgebra, Kroki

makedocs(
         format = Documenter.HTML(),
         sitename = "AbstractAlgebra.jl",
         modules = [AbstractAlgebra],
         clean = true,
         doctest = true,
         strict = true,
         checkdocs = :none,
         pages    = [
             "index.md",
             "Fundamental interface of AbstractAlgebra.jl" => [
                 "types.md",
                 "visualizing_types.md",
                 "extending_abstractalgebra.md"
                ],
             "constructors.md",
             "Rings" => [ "ring_introduction.md",
                          "rings.md",
                          "ncrings.md",
                          "euclidean.md",
                          "integer.md",
                          "polynomial_rings.md",
                          "polynomial.md",
                          "ncpolynomial.md",
                          "mpolynomial_rings.md",
                          "mpolynomial.md",
                          "laurent_polynomial.md",
                          "series_rings.md",
                          "series.md",
                          "puiseux.md",
                          "mseries.md",
                          "residue_rings.md",
                          "residue.md"],
             "Fields" => [ "field_introduction.md",
                           "fields.md",
                           "fraction_fields.md",
                           "fraction.md",
                           "rational.md",
			   "function_field.md",
                           "finfield.md",
                           "real.md",
                           "numberfield.md"],
             "Groups" => [ "perm.md",
                           "ytabs.md"],
             "Modules" => [ "module_introduction.md",
                            "module.md",
                            "free_module.md",
                            "submodule.md",
                            "quotient_module.md",
                            "direct_sum.md",
                            "module_homomorphism.md"],
             "Matrices" => [ "matrix_introduction.md",
                             "matrix_spaces.md",
                             "matrix.md",
                             "matrix_algebras.md"],
             "Maps" => [ "map.md",
                         "functional_map.md",
                         "map_cache.md",
                         "map_with_inverse.md"],
             "Miscellaneous" => ["misc.md"],
         ]
)

deploydocs(
   repo   = "github.com/Nemocas/AbstractAlgebra.jl.git",
   target = "build",
)
