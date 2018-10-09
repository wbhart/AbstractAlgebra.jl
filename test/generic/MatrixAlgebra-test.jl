primes100 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59,
61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139,
149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227,
229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311,
313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401,
409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491,
499, 503, 509, 521, 523, 541]


function randprime(n::Int)
   if n > 100 || n < 1
      throw(DomainError())
   end
   return primes100[rand(1:n)]
end

function istriu(A::Generic.MatAlgElem)
   m = rows(A)
   n = cols(A)
   d = 0
   for c = 1:n
      for r = m:-1:1
         if !iszero(A[r,c])
            if r < d
               return false
            end
            d = r
            break
         end
      end
   end
   return true
end

function is_snf(A::Generic.MatAlgElem)
   m = rows(A)
   n = cols(A)
   a = A[1,1]
   for i = 2:min(m,n)
      q, r = divrem(A[i,i], a)
      if !iszero(r)
         return false
      end
      a = A[i,i]
   end
   for i = 1:n
      for j = 1:m
         if i == j
            continue
         end
         if !iszero(A[j,i])
            return false
         end
      end
   end
   return true
end

function is_weak_popov(P::Generic.MatAlgElem, rank::Int)
   zero_rows = 0
   pivots = zeros(cols(P))
   for r = 1:rows(P)
      p = AbstractAlgebra.find_pivot_popov(P, r)
      if P[r,p] == 0
         zero_rows += 1
         continue
      end
      if pivots[p] != 0
         return false
      end
      pivots[p] = r
   end
   if zero_rows != rows(P)-rank
      return false
   end
   return true
end

function test_gen_matalg_constructors()
   print("Generic.MatAlg.constructors...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   @test elem_type(S) == Generic.MatAlgElem{elem_type(R)}
   @test elem_type(Generic.MatAlgebra{elem_type(R)}) == Generic.MatAlgElem{elem_type(R)}
   @test parent_type(Generic.MatAlgElem{elem_type(R)}) == Generic.MatAlgebra{elem_type(R)}

   @test typeof(S) <: Generic.MatAlgebra

   f = S(t^2 + 1)

   @test isa(f, MatAlgElem)

   g = S(2)

   @test isa(g, MatAlgElem)

   h = S(BigInt(23))

   @test isa(h, MatAlgElem)

   k = S([t t + 2 t^2 + 3t + 1; 2t R(2) t + 1; t^2 + 2 t + 1 R(0)])

   @test isa(k, MatAlgElem)

   l = S(k)

   @test isa(l, MatAlgElem)

   m = S()

   @test isa(m, MatAlgElem)

   @test_throws ErrorConstrDimMismatch S([t t^2 ; t^3 t^4])
   @test_throws ErrorConstrDimMismatch S([t t^2 t^3 ; t^4 t^5 t^6 ; t^7 t^8 t^9 ; t t^2 t^3])
   @test_throws ErrorConstrDimMismatch S([t, t^2])
   @test_throws ErrorConstrDimMismatch S([t, t^2, t^3, t^4, t^5, t^6, t^7, t^8, t^9, t^10])

   println("PASS")
end

function test_gen_matalg_size()
   print("Generic.MatAlg.size...")

   S = MatrixAlgebra(QQ, 3)
   A = S([1 2 3; 4 5 6; 7 8 9])

   @test dimension(A) == 3
   @test issquare(A)

   println("PASS")
end

function test_gen_matalg_manipulation()
   print("Generic.MatAlg.manipulation...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])
   B = S([R(2) R(3) R(1); t t + 1 t + 2; R(-1) t^2 t^3])

   @test iszero(zero(S))
   @test isone(one(S))

   B[1, 1] = R(3)
   @test B[1, 1] == R(3)

   B[1, 1] = 4
   @test B[1, 1] == R(4)

   B[1, 1] = BigInt(5)
   @test B[1, 1] == R(5)

   @test rows(B) == 3
   @test cols(B) == 3

   @test deepcopy(A) == A

   println("PASS")
end

function test_gen_matalg_unary_ops()
   print("Generic.MatAlg.unary_ops...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])
   B = S([-t - 1 (-t) -R(1); -t^2 (-t) (-t); -R(-2) (-t - 2) (-t^2 - t - 1)])

   @test -A == B

   println("PASS")
end

function test_gen_matalg_binary_ops()
   print("Generic.MatAlg.binary_ops...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])
   B = S([R(2) R(3) R(1); t t + 1 t + 2; R(-1) t^2 t^3])

   @test A + B == S([t+3 t+3 R(2); t^2 + t 2*t+1 2*t+2; R(-3) t^2 + t + 2 t^3 + 1*t^2 + t + 1])

   @test A - B == S([t-1 t-3 R(0); t^2 - t R(-1) R(-2); R(-1) (-t^2 + t + 2) (-t^3 + t^2 + t + 1)])

   @test A*B == S([t^2 + 2*t + 1 2*t^2 + 4*t + 3 t^3 + t^2 + 3*t + 1; 3*t^2 - t (t^3 + 4*t^2 + t) t^4 + 2*t^2 + 2*t; t-5 t^4 + t^3 + 2*t^2 + 3*t - 4 t^5 + 1*t^4 + t^3 + t^2 + 4*t + 2])

   println("PASS")
end

function test_gen_matalg_adhoc_binary()
   print("Generic.MatAlg.adhoc_binary...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test 12 + A == A + 12
   @test BigInt(11) + A == A + BigInt(11)
   @test Rational{BigInt}(11) + A == A + Rational{BigInt}(11)
   @test (t + 1) + A == A + (t + 1)
   @test A - (t + 1) == -((t + 1) - A)
   @test A - 3 == -(3 - A)
   @test A - BigInt(7) == -(BigInt(7) - A)
   @test A - Rational{BigInt}(7) == -(Rational{BigInt}(7) - A)
   @test 3*A == A*3
   @test BigInt(3)*A == A*BigInt(3)
   @test Rational{BigInt}(3)*A == A*Rational{BigInt}(3)
   @test (t - 1)*A == A*(t - 1)

   println("PASS")
end

function test_gen_matalg_permutation()
   print("Generic.MatAlg.permutation...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   T = PermutationGroup(3)
   P = T([2, 3, 1])

   @test A == inv(P)*(P*A)

   println("PASS")
end

function test_gen_matalg_comparison()
   print("Generic.MatAlg.comparison...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])
   B = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test A == B

   @test A != one(S)

   println("PASS")
end

function test_gen_matalg_adhoc_comparison()
   print("Generic.MatAlg.adhoc_comparison...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test S(12) == 12
   @test S(5) == BigInt(5)
   @test S(5) == Rational{BigInt}(5)
   @test S(t + 1) == t + 1
   @test 12 == S(12)
   @test BigInt(5) == S(5)
   @test Rational{BigInt}(5) == S(5)
   @test t + 1 == S(t + 1)
   @test A != one(S)
   @test one(S) == one(S)

   println("PASS")
end

function test_gen_matalg_powering()
   print("Generic.MatAlg.powering...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test A^5 == A^2*A^3

   @test A^0 == one(S)

   println("PASS")
end

function test_gen_matalg_adhoc_exact_division()
   print("Generic.MatAlg.adhoc_exact_division...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test divexact(5*A, 5) == A
   @test divexact(12*A, BigInt(12)) == A
   @test divexact(12*A, Rational{BigInt}(12)) == A
   @test divexact((1 + t)*A, 1 + t) == A

   println("PASS")
end

function test_gen_matalg_transpose()
   print("Generic.MatAlg.transpose...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)
   arr = [t + 1 t R(1); t^2 t t; t+1 t^2 R(-1)]
   A = S(arr)
   B = S(permutedims(arr, [2, 1]))
   @test transpose(A) == B

   println("PASS")
end

function test_gen_matalg_gram()
   print("Generic.MatAlg.gram...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test gram(A) == S([2*t^2 + 2*t + 2 t^3 + 2*t^2 + t 2*t^2 + t - 1; t^3 + 2*t^2 + t t^4 + 2*t^2 t^3 + 3*t; 2*t^2 + t - 1 t^3 + 3*t t^4 + 2*t^3 + 4*t^2 + 6*t + 9])

   println("PASS")
end

function test_gen_matalg_tr()
   print("Generic.MatAlg.tr...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test tr(A) == t^2 + 3t + 2

   println("PASS")
end

function test_gen_matalg_content()
   print("Generic.MatAlg.content...")

   R, t = PolynomialRing(QQ, "t")
   S = MatrixAlgebra(R, 3)

   A = S([t + 1 t R(1); t^2 t t; R(-2) t + 2 t^2 + t + 1])

   @test content((1 + t)*A) == 1 + t
   println("PASS")
end

function test_gen_matalg_lu()
   print("Generic.MatAlg.lu...")

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")
   S = MatrixAlgebra(K, 3)

   A = S([a + 1 2a + 3 a^2 + 1; 2a^2 - 1 a - 1 2a; a^2 + 3a + 1 2a K(1)])

   r, P, L, U = lu(A)

   @test r == 3
   @test P*A == L*U

   A = S([K(0) 2a + 3 a^2 + 1; a^2 - 2 a - 1 2a; a^2 + 3a + 1 2a K(1)])

   r, P, L, U = lu(A)

   @test r == 3
   @test P*A == L*U

   A = S([K(0) 2a + 3 a^2 + 1; a^2 - 2 a - 1 2a; a^2 - 2 a - 1 2a])

   r, P, L, U = lu(A)

   @test r == 2
   @test P*A == L*U

   R, z = PolynomialRing(ZZ, "z")
   F = FractionField(R)
   S = MatrixAlgebra(F, 3)

   A = S([F(0), F(0), F(11), 78*z^3-102*z^2+48*z+12, F(92), -16*z^2+80*z-149, -377*z^3+493*z^2-232*z-58, F(-448), 80*z^2-385*z+719])

   r, P, L, U = lu(A)

   @test r == 3
   @test P*A == L*U

   println("PASS")
end

function test_gen_matalg_fflu()
   print("Generic.MatAlg.fflu...")

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")
   S = MatrixAlgebra(K, 3)

   A = S([a + 1 2a + 3 a^2 + 1; 2a^2 - 1 a - 1 2a; a^2 + 3a + 1 2a K(1)])

   r, d, P, L, U = fflu(A)

   D = S()
   D[1, 1] = inv(U[1, 1])
   D[2, 2] = inv(U[1, 1]*U[2, 2])
   D[3, 3] = inv(U[2, 2])

   @test r == 3
   @test P*A == L*D*U

   A = S([K(0) 2a + 3 a^2 + 1; a^2 - 2 a - 1 2a; a^2 + 3a + 1 2a K(1)])

   r, d, P, L, U = fflu(A)

   D = S()
   D[1, 1] = inv(U[1, 1])
   D[2, 2] = inv(U[1, 1]*U[2, 2])
   D[3, 3] = inv(U[2, 2])

   @test r == 3
   @test P*A == L*D*U

   A = S([K(0) 2a + 3 a^2 + 1; a^2 - 2 a - 1 2a; a^2 - 2 a - 1 2a])

   r, d, P, L, U = fflu(A)

   D = S()
   D[1, 1] = inv(U[1, 1])
   D[2, 2] = inv(U[1, 1]*U[2, 2])
   D[3, 3] = inv(U[2, 2])

   @test r == 2
   @test P*A == L*D*U

   S = MatrixAlgebra(QQ, 3)
   A = S([0, 0, 1, 12, 1, 11, 1, 0, 1])

   r, d, P, L, U, = fflu(A)

   D = S()
   D[1, 1] = inv(U[1, 1])
   D[2, 2] = inv(U[1, 1]*U[2, 2])
   D[3, 3] = inv(U[2, 2])
   @test r == 3
   @test P*A == L*D*U

   println("PASS")
end

function test_gen_matalg_det()
   print("Generic.MatAlg.det...")

   S, x = PolynomialRing(ResidueRing(ZZ, 1009*2003), "x")

   for dim = 0:5
      R = MatrixAlgebra(S, dim)

      M = rand(R, 0:5, -100:100)

      @test det(M) == AbstractAlgebra.det_clow(M)
   end

   S, z = PolynomialRing(ZZ, "z")

   for dim = 0:5
      R = MatrixAlgebra(S, dim)

      M = rand(R, 0:3, -20:20)

      @test det(M) == AbstractAlgebra.det_clow(M)
   end

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")

   for dim = 0:7
      S = MatrixAlgebra(K, dim)

      M = rand(S, 0:2, -100:100)

      @test det(M) == AbstractAlgebra.det_clow(M)
   end

   R, x = PolynomialRing(ZZ, "x")
   S, y = PolynomialRing(R, "y")

   for dim = 0:5
      T = MatrixAlgebra(S, dim)
      M = rand(T, 0:2, 0:2, -10:10)

      @test det(M) == AbstractAlgebra.det_clow(M)
   end

   println("PASS")
end

function test_gen_matalg_rank()
   print("Generic.MatAlg.rank...")

   S, x = PolynomialRing(ResidueRing(ZZ, 1009*2003), "x")
   R = MatrixAlgebra(S, 3)

   M = R([S(3) S(2) S(1); S(2021024) S(2021025) S(2021026); 3*x^2+5*x+2021024 2021022*x^2+4*x+5 S(2021025)])

   @test rank(M) == 2

   S, x = PolynomialRing(ResidueRing(ZZ, 20011*10007), "x")
   R = MatrixAlgebra(S, 5)

   for i = 0:5
      M = randmat_with_rank(R, i, 0:5, -100:100)

      @test rank(M) == i
   end

   S, z = PolynomialRing(ZZ, "z")
   R = MatrixAlgebra(S, 4)

   M = R([S(-2) S(0) S(5) S(3); 5*z^2+5*z-5 S(0) S(-z^2+z) 5*z^2+5*z+1; 2*z-1 S(0) z^2+3*z+2 S(-4*z); 3*z-5 S(0) S(-5*z+5) S(1)])

   @test rank(M) == 3

   R = MatrixSpace(S, 5, 5)

   for i = 0:5
      M = randmat_with_rank(R, i, 0:3, -20:20)

      @test rank(M) == i
   end

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")
   S = MatrixAlgebra(K, 3)

   M = S([a a^2 + 2*a - 1 2*a^2 - 1*a; 2*a+2 2*a^2 + 2*a (-2*a^2 - 2*a); (-a) (-a^2) a^2])

   @test rank(M) == 2

   S = MatrixAlgebra(K, 5)

   for i = 0:5
      M = randmat_with_rank(S, i, 0:2, -100:100)

      @test rank(M) == i
   end

   R, x = PolynomialRing(ZZ, "x")
   S, y = PolynomialRing(R, "y")
   T = MatrixAlgebra(S, 3)

   M = T([(2*x^2)*y^2+(-2*x^2-2*x)*y+(-x^2+2*x) S(0) (-x^2-2)*y^2+(x^2+2*x+2)*y+(2*x^2-x-1);
    (-x)*y^2+(-x^2+x-1)*y+(x^2-2*x+2) S(0) (2*x^2+x-1)*y^2+(-2*x^2-2*x-2)*y+(x^2-x);
    (-x+2)*y^2+(x^2+x+1)*y+(-x^2+x-1) S(0) (-x^2-x+2)*y^2+(-x-1)*y+(-x-1)])

   @test rank(M) == 2

   T = MatrixAlgebra(S, 5)

   for i = 0:5
      M = randmat_with_rank(T, i, 0:2, 0:2, -20:20)

      @test rank(M) == i
   end

   println("PASS")
end

function test_gen_matalg_solve_lu()
   print("Generic.MatAlg.solve_lu...")

   S = QQ

   for dim = 0:5
      R = MatrixAlgebra(S, dim)
      U = MatrixAlgebra(S, dim)

      M = randmat_with_rank(R, dim, -100:100)
      b = rand(U, -100:100)

      x = Generic.solve_lu(M, b)

      @test M*x == b
   end

   S, y = PolynomialRing(ZZ, "y")
   K = FractionField(S)

   for dim = 0:5
      R = MatrixAlgebra(S, dim)
      U = MatrixAlgebra(S, dim)
      T = MatrixAlgebra(K, dim)

      M = randmat_with_rank(R, dim, 0:5, -100:100)
      b = rand(U, 0:5, -100:100);

      MK = T(elem_type(K)[ K(M[i, j]) for i in 1:rows(M), j in 1:cols(M) ])
      bK = T(elem_type(K)[ K(b[i, j]) for i in 1:rows(b), j in 1:cols(b) ])

      x = Generic.solve_lu(MK, bK)

      @test MK*x == bK
   end

   println("PASS")
end

function test_gen_matalg_rref()
   print("Generic.MatAlg.rref...")

   S, x = PolynomialRing(ResidueRing(ZZ, 20011*10007), "x")
   R = MatrixAlgebra(S, 5)

   for i = 0:5
      M = randmat_with_rank(R, i, 0:5, -100:100)

      r, d, A = rref(M)

      @test r == i
      @test isrref(A)
   end

   S, z = PolynomialRing(ZZ, "z")
   R = MatrixAlgebra(S, 5)

   for i = 0:5
      M = randmat_with_rank(R, i, 0:3, -20:20)

      r, d, A = rref(M)

      @test r == i
      @test isrref(A)
   end

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")
   S = MatrixAlgebra(K, 5)

   for i = 0:5
      M = randmat_with_rank(S, i, 0:2, -100:100)

      r, A = rref(M)

      @test r == i
      @test isrref(A)
   end

   R, x = PolynomialRing(ZZ, "x")
   S, y = PolynomialRing(R, "y")
   T = MatrixAlgebra(S, 5)

   for i = 0:5
      M = randmat_with_rank(T, i, 0:2, 0:2, -20:20)

      r, d, A = rref(M)

      @test r == i
      @test isrref(A)
   end

   println("PASS")
end

function test_gen_matalg_inversion()
   print("Generic.MatAlg.inversion...")

   S, x = PolynomialRing(ResidueRing(ZZ, 20011*10007), "x")

   for dim = 1:5
      R = MatrixAlgebra(S, dim)

      M = randmat_with_rank(R, dim, 0:5, -100:100)

      X, d = inv(M)

      @test M*X == d*one(R)
   end

   S, z = PolynomialRing(ZZ, "z")

   for dim = 1:5
      R = MatrixAlgebra(S, dim)

      M = randmat_with_rank(R, dim, 0:3, -20:20)

      X, d = inv(M)

      @test M*X == d*one(R)
   end

   R, x = PolynomialRing(QQ, "x")
   K, a = NumberField(x^3 + 3x + 1, "a")

   for dim = 1:5
      S = MatrixAlgebra(K, dim)

      M = randmat_with_rank(S, dim, 0:2, -100:100)

      X = inv(M)

      @test isone(M*X)
   end

   R, x = PolynomialRing(ZZ, "x")
   S, y = PolynomialRing(R, "y")

   for dim = 1:5
      T = MatrixAlgebra(S, dim)

      M = randmat_with_rank(T, dim, 0:2, 0:2, -20:20)

      X, d = inv(M)

      @test M*X == d*one(T)
   end

   println("PASS")
end

function test_gen_matalg_hessenberg()
   print("Generic.MatAlg.hessenberg...")

   R = ResidueRing(ZZ, 18446744073709551629)

   for dim = 0:5
      S = MatrixAlgebra(R, dim)
      U, x = PolynomialRing(R, "x")

      for i = 1:10
         M = rand(S, -5:5)

         A = hessenberg(M)

         @test ishessenberg(A)
      end
   end

   println("PASS")
end

function test_gen_matalg_kronecker_product()
   print("Generic.MatAlg.kronecker_product...")
   
   R = ResidueRing(ZZ, 18446744073709551629)
   S = MatrixSpace(R, 2, 3)
   S2 = MatrixSpace(R, 2, 2)
   S3 = MatrixSpace(R, 3, 3)
   
   A = S(R.([2 3 5; 9 6 3]))
   B = S2(R.([2 3; 1 4]))
   C = S3(R.([2 3 5; 1 4 7; 9 6 3]))
   
   @test size(kronecker_product(A, A)) == (4,9)
   @test kronecker_product(B*A,A*C) == kronecker_product(B,A) * kronecker_product(A,C)

   println("PASS")
end

function test_gen_matalg_charpoly()
   print("Generic.MatAlg.charpoly...")

   R = ResidueRing(ZZ, 18446744073709551629)

   for dim = 0:5
      S = MatrixSpace(R, dim, dim)
      U, x = PolynomialRing(R, "x")

      for i = 1:10
         M = rand(S, -5:5)

         p1 = charpoly(U, M)
         p2 = charpoly_danilevsky!(U, M)

         @test p1 == p2
      end

      for i = 1:10
         M = rand(S, -5:5)

         p1 = charpoly(U, M)
         p2 = charpoly_danilevsky_ff!(U, M)

         @test p1 == p2
      end

      for i = 1:10
         M = rand(S, -5:5)

         p1 = charpoly(U, M)
         p2 = charpoly_hessenberg!(U, M)

         @test p1 == p2
      end
   end

   R, x = PolynomialRing(ZZ, "x")
   U, z = PolynomialRing(R, "z")
   T = MatrixSpace(R, 6, 6)

   M = T()
   for i = 1:3
      for j = 1:3
         M[i, j] = rand(R, 0:2, -10:10)
         M[i + 3, j + 3] = deepcopy(M[i, j])
      end
   end

   p1 = charpoly(U, M)

   for i = 1:10
      similarity!(M, rand(1:6), R(rand(R, 0:2, -3:3)))
   end

   p2 = charpoly(U, M)

   @test p1 == p2

   println("PASS")
end

function test_gen_matalg_minpoly()
   print("Generic.MatAlg.minpoly...")

   R = GF(103)
   T, y = PolynomialRing(R, "y")

   M = R[92 97 8;
          0 5 13;
          0 16 2]

   @test minpoly(T, M) == y^2+96*y+8

   R = GF(3)
   T, y = PolynomialRing(R, "y")

   M = R[1 2 0 2;
         1 2 1 0;
         1 2 2 1;
         2 1 2 0]

   @test minpoly(T, M) == y^2 + 2y

   R = GF(13)
   T, y = PolynomialRing(R, "y")

   M = R[7 6 1;
         7 7 5;
         8 12 5]

   @test minpoly(T, M) == y^2+10*y

   M = R[4 0 9 5;
         1 0 1 9;
         0 0 7 6;
         0 0 3 10]

   @test minpoly(T, M) == y^2 + 9y

   M = R[2 7 0 0 0 0;
         1 0 0 0 0 0;
         0 0 2 7 0 0;
         0 0 1 0 0 0;
         0 0 0 0 4 3;
         0 0 0 0 1 0]

   @test minpoly(T, M) == (y^2+9*y+10)*(y^2+11*y+6)

   M = R[2 7 0 0 0 0;
         1 0 1 0 0 0;
         0 0 2 7 0 0;
         0 0 1 0 0 0;
         0 0 0 0 4 3;
         0 0 0 0 1 0]

   @test minpoly(T, M) == (y^2+9*y+10)*(y^2+11*y+6)^2

   S = MatrixSpace(R, 1, 1)
   M = S()

   @test minpoly(T, M) == y

   S = MatrixSpace(R, 0, 0)
   M = S()

   @test minpoly(T, M) == 1

   R, x = PolynomialRing(ZZ, "x")
   S, y = PolynomialRing(R, "y")
   U, z = PolynomialRing(S, "z")
   T = MatrixSpace(S, 6, 6)

   M = T()
   for i = 1:3
      for j = 1:3
         M[i, j] = rand(S, 0:3, 0:3, -10:10)
         M[i + 3, j + 3] = deepcopy(M[i, j])
      end
   end

   f = minpoly(U, M)

   @test degree(f) <= 3

   R, x = PolynomialRing(ZZ, "x")
   U, z = PolynomialRing(R, "z")
   T = MatrixSpace(R, 6, 6)

   M = T()
   for i = 1:3
      for j = 1:3
         M[i, j] = rand(R, 0:2, -10:10)
         M[i + 3, j + 3] = deepcopy(M[i, j])
      end
   end

   p1 = minpoly(U, M)

   for i = 1:10
      similarity!(M, rand(1:6), R(rand(R, 0:2, -3:3)))
   end

   p2 = minpoly(U, M)

   @test p1 == p2

   println("PASS")
end

function test_gen_matalg_row_swapping()
   print("Generic.MatAlg.row_swapping...")

   R, x = PolynomialRing(ZZ, "x")
   M = MatrixSpace(R, 3, 2)

   a = M(map(R, [1 2; 3 4; 5 6]))

   @test swap_rows(a, 1, 3) == M(map(R, [5 6; 3 4; 1 2]))

   swap_rows!(a, 2, 3)

   @test a == M(map(R, [1 2; 5 6; 3 4]))

   println("PASS")
end

function test_gen_matalg_concat()
   print("Generic.MatAlg.concat...")

   R, x = PolynomialRing(ZZ, "x")

   for i = 1:10
      r = rand(0:10)
      c1 = rand(0:10)
      c2 = rand(0:10)

      S1 = MatrixSpace(R, r, c1)
      S2 = MatrixSpace(R, r, c2)

      M1 = rand(S1, 0:3, -100:100)
      M2 = rand(S2, 0:3, -100:100)

      @test vcat(transpose(M1), transpose(M2)) == transpose(hcat(M1, M2))
   end

   println("PASS")
end

function test_gen_matalg_hnf_minors()
  print("Generic.MatAlg.hnf_minors...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   H = hnf_minors(A)
   @test istriu(H)

   H, U = hnf_minors_with_trafo(A)
   @test istriu(H)
   @test isunit(det(U))
   @test U*A == H

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 4, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5; y 1 y 2]))

   H = hnf_minors(B)
   @test istriu(H)

   H, U = hnf_minors_with_trafo(B)
   @test istriu(H)
   @test isunit(det(U))
   @test U*B == H

   println("PASS")
end

function test_gen_matalg_hnf_kb()
   print("Generic.MatAlg.hnf_kb...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   H = AbstractAlgebra.hnf_kb(A)
   @test istriu(H)

   H, U = AbstractAlgebra.hnf_kb_with_trafo(A)
   @test istriu(H)
   @test isunit(det(U))
   @test U*A == H

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 3, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5]))

   H = AbstractAlgebra.hnf_kb(B)
   @test istriu(H)

   H, U = AbstractAlgebra.hnf_kb_with_trafo(B)
   @test istriu(H)
   @test isunit(det(U))
   @test U*B == H

   println("PASS")
end

function test_gen_matalg_hnf_cohen()
   print("Generic.MatAlg.hnf_cohen...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   H = AbstractAlgebra.hnf_cohen(A)
   @test istriu(H)

   H, U = AbstractAlgebra.hnf_cohen_with_trafo(A)
   @test istriu(H)
   @test isunit(det(U))
   @test U*A == H

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 3, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5]))

   H = AbstractAlgebra.hnf_cohen(B)
   @test istriu(H)

   H, U = AbstractAlgebra.hnf_cohen_with_trafo(B)
   @test istriu(H)
   @test isunit(det(U))
   @test U*B == H

   println("PASS")
end

function test_gen_matalg_hnf()
   print("Generic.MatAlg.hnf...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   H = hnf(A)
   @test istriu(H)

   H, U = hnf_with_trafo(A)
   @test istriu(H)
   @test isunit(det(U))
   @test U*A == H

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 3, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5]))

   H = hnf(B)
   @test istriu(H)

   H, U = hnf_with_trafo(B)
   @test istriu(H)
   @test isunit(det(U))
   @test U*B == H

   println("PASS")
end

function test_gen_matalg_snf_kb()
   print("Generic.MatAlg.snf_kb...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   T = AbstractAlgebra.snf_kb(A)
   @test is_snf(T)

   T, U, K = AbstractAlgebra.snf_kb_with_trafo(A)
   @test is_snf(T)
   @test isunit(det(U))
   @test isunit(det(K))
   @test U*A*K == T

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 3, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5]))

   T = AbstractAlgebra.snf_kb(B)
   @test is_snf(T)

   T, U, K = AbstractAlgebra.snf_kb_with_trafo(B)
   @test is_snf(T)
   @test isunit(det(U))
   @test isunit(det(K))
   @test U*B*K == T

   println("PASS")
end

function test_gen_matalg_snf()
   print("Generic.MatAlg.snf...")

   R, x = PolynomialRing(QQ, "x")

   M = MatrixSpace(R, 4, 3)

   A = M(map(R, Any[0 0 0; x^3+1 x^2 0; 0 x^2 x^5; x^4+1 x^2 x^5+x^3]))

   T = snf(A)
   @test is_snf(T)

   T, U, K = snf_with_trafo(A)
   @test is_snf(T)
   @test isunit(det(U))
   @test isunit(det(K))
   @test U*A*K == T

   # Fake up finite field of char 7, degree 2
   R, x = PolynomialRing(GF(7), "x")
   F = ResidueField(R, x^2 + 6x + 3)
   a = F(x)

   S, y = PolynomialRing(F, "y")

   N = MatrixSpace(S, 3, 4)

   B = N(map(S, Any[1 0 a 0; a*y^3 0 3*a^2 0; y^4+a 0 y^2+y 5]))

   T = snf(B)
   @test is_snf(T)

   T, U, K = snf_with_trafo(B)
   @test is_snf(T)
   @test isunit(det(U))
   @test isunit(det(K))
   @test U*B*K == T

   println("PASS")
end

function test_gen_matalg_weak_popov()
   print("Generic.MatAlg.weak_popov...")

   R, x = PolynomialRing(QQ, "x")

   A = matrix(R, map(R, Any[1 2 3 x; x 2*x 3*x x^2; x x^2+1 x^3+x^2 x^4+x^2+1]))
   r = rank(A)

   P = weak_popov(A)
   @test is_weak_popov(P, r)

   P, U = weak_popov_with_trafo(A)
   @test is_weak_popov(P, r)
   @test U*A == P
   @test isunit(det(U))

   F = GF(7)

   S, y = PolynomialRing(F, "y")

   B = matrix(S, map(S, Any[ 4*y^2+3*y+5 4*y^2+3*y+4 6*y^2+1; 3*y+6 3*y+5 y+3; 6*y^2+4*y+2 6*y^2 2*y^2+y]))
   s = rank(B)

   P = weak_popov(B)
   @test is_weak_popov(P, s)

   P, U = weak_popov_with_trafo(B)
   @test is_weak_popov(P, s)
   @test U*B == P
   @test isunit(det(U))

   # some random tests

   for i in 1:3
      M = MatrixSpace(PolynomialRing(QQ, "x")[1], rand(1:5), rand(1:5))
      A = rand(M, 0:5, -5:5)
      r = rank(A)
      P = weak_popov(A)
      @test is_weak_popov(P, r)

      P, U = weak_popov_with_trafo(A)
      @test is_weak_popov(P, r)
      @test U*A == P
      @test isunit(det(U))
   end

   R = GF(randprime(100))

   M = MatrixSpace(PolynomialRing(R, "x")[1], rand(1:5), rand(1:5))

   for i in 1:2
      A = rand(M, 1:5)
      r = rank(A)
      P = weak_popov(A)
      @test is_weak_popov(P, r)

      P, U = weak_popov_with_trafo(A)
      @test is_weak_popov(P, r)
      @test U*A == P
      @test isunit(det(U))
   end

   R = ResidueRing(ZZ, randprime(100))

   M = MatrixSpace(PolynomialRing(R, "x")[1], rand(1:5), rand(1:5))

   for i in 1:2
      A = rand(M, 1:5, 0:100)
      r = rank(A)
      P = weak_popov(A)
      @test is_weak_popov(P, r)

      P, U = weak_popov_with_trafo(A)
      @test is_weak_popov(P, r)
      @test U*A == P
      @test isunit(det(U))
   end

   println("PASS")
end

function test_gen_matalg()
   test_gen_matalg_constructors()
   test_gen_matalg_size()
   test_gen_matalg_manipulation()
   test_gen_matalg_unary_ops()
   test_gen_matalg_binary_ops()
   test_gen_matalg_adhoc_binary()
   test_gen_matalg_permutation()
   test_gen_matalg_comparison()
   test_gen_matalg_adhoc_comparison()
   test_gen_matalg_powering()
   test_gen_matalg_adhoc_exact_division()
   test_gen_matalg_transpose()
   test_gen_matalg_gram()
   test_gen_matalg_tr()
   test_gen_matalg_content()
   test_gen_matalg_lu()
   test_gen_matalg_fflu()
   test_gen_matalg_det()
   test_gen_matalg_rank()
   test_gen_matalg_solve_lu()
   test_gen_matalg_rref()
   test_gen_matalg_inversion()
   test_gen_matalg_hessenberg()
   test_gen_matalg_kronecker_product()
   test_gen_matalg_charpoly()
   test_gen_matalg_minpoly()
   test_gen_matalg_row_swapping()
   test_gen_matalg_concat()
   test_gen_matalg_hnf_minors()
   test_gen_matalg_hnf_kb()
   test_gen_matalg_hnf_cohen()
   test_gen_matalg_hnf()
   test_gen_matalg_snf_kb()
   test_gen_matalg_snf()
   test_gen_matalg_weak_popov()

   println("")
end
