# Testing of simple and reference expressions on scalar context

import DeExpr
import DeExpr.@devec
import DeExpr.@inspect_devec
import DeExpr.dump_devec

using Test

#data

a = [1., 2., 3., 4., 5., 6., 7., 8.]
b = [3., 4., 5., 6., 8., 7., 6., 5.]
c = [9., 8., 7., 6., 4., 2., 3., 1.]
cv = 12.0
cv_a = [12., 12., 12., 12., 12., 12., 12., 12.]

abc = [a b c]

at = a'
bt = b'
ct = c'
abct = [at, bt, ct]

type X
	x
end

ax = X(a)

###########################################################
#
#	trivial/simple assignments
#
###########################################################

@devec r = a
@test r === a

@devec r = ax.x
@test r === ax.x 

r = X(0)
@devec r.x = a
@test r.x === a

r = X(0)
@devec r.x = ax.x
@test r.x === ax.x

r = similar(a)
r0 = r
#dump_devec(:(r[:] = b))
@devec r[:] = b
@test r === r0
@test isequal(r, b)


###########################################################
#
#	scalar or scalar references
#
###########################################################

@devec r[:] = 12.
@test isequal(r, cv_a)

@devec r[:] = cv
@test isequal(r, cv_a)

r = similar(a)
@devec r[:] = a[3]
@test isequal(r, fill(a[3], size(a)))

i = 2
@devec r[:] = a[i]
@test isequal(r, fill(a[i], size(a)))

@devec r[:] = abc[1,3]
@test isequal(r, fill(c[1], size(a)))

i = 2
@devec r[:] = abc[i,3]
@test isequal(r, fill(c[i], size(a)))

@devec r[:] = abc[2,i]
@test isequal(r, fill(b[2], size(a)))

j = 1
@devec r[:] = abc[i,j]
@test isequal(r, fill(a[i], size(a)))


###########################################################
#
#	1D references
#
###########################################################

# 1D ref on RHS

@devec r = a[:]
@test isequal(r, a)

@devec r = a[1:]
@test isequal(r, a)

@devec r = a[1:5]
@test isequal(r, a[1:5])

v = 4
@devec r = a[1:v]
@test isequal(r, a[1:v])

@devec r = a[3:]
@test isequal(r, a[3:])

@devec r = a[3:6]
@test isequal(r, a[3:6])

v = 7
@devec r = a[3:v]
@test isequal(r, a[3:v])

u = 2
@devec r = a[u:]
@test isequal(r, a[u:])

@devec r = a[u:6]
@test isequal(r, a[u:6])

v = 7
@devec r = a[u:v]
@test isequal(r, a[u:v])

# 1D ref on LHS

r = zeros(size(a))
@devec r[:] = b[:]
rr = zeros(size(a))
rr[:] = b[:]
@test isequal(r, rr)

r = zeros(size(a))
@devec r[3:6] = cv
rr = zeros(size(a))
rr[3:6] = cv
@test isequal(r, rr)

r = zeros(size(a))
@devec r[3:6] = b[2:5]
rr = zeros(size(a))
rr[3:6] = b[2:5]
@test isequal(r, rr)

u = 1

r = zeros(size(a))
@devec r[1:] = b[u:]
rr = zeros(size(a))
rr[1:] = b[u:]
@test isequal(r, rr)

r = zeros(size(a))
@devec r[u:] = b[:]
rr = zeros(size(a))
rr[u:] = b[:]
@test isequal(r, rr)

u = 2

r = zeros(size(a))
@devec r[2:] = b[u:]
rr = zeros(size(a))
rr[2:] = b[u:]
@test isequal(r, rr)

r = zeros(size(a))
@devec r[u:] = b[2:]
rr = zeros(size(a))
rr[u:] = b[2:]
@test isequal(r, rr)

u, v = 4, 7

r = zeros(size(a))
@devec r[3:6] = b[u:v]
rr = zeros(size(a))
rr[3:6] = b[u:v]
@test isequal(r, rr)

r = zeros(size(a))
@devec r[u:v] = b[2:5]
rr = zeros(size(a))
rr[u:v] = b[2:5]
@test isequal(r, rr)



###########################################################
#
#	column references
#
###########################################################

# col-ref on RHS

j = 2

@devec r = abc[:,1]
@test isequal(r, a)

@devec r = abc[1:,1]
@test isequal(r, a)

@devec r = abc[1:5,1]
@test isequal(r, a[1:5])

@devec r = abc[:,j]
@test isequal(r, b)

@devec r = abc[1:,j]
@test isequal(r, b)

@devec r = abc[1:5,j]
@test isequal(r, b[1:5])

v = 4
@devec r = abc[1:v,1]
@test isequal(r, a[1:v])

@devec r = abc[3:,1]
@test isequal(r, a[3:])

@devec r = abc[3:6,1]
@test isequal(r, a[3:6])

@devec r = abc[1:v,j]
@test isequal(r, b[1:v])

@devec r = abc[3:,j]
@test isequal(r, b[3:])

@devec r = abc[3:6,j]
@test isequal(r, b[3:6])

v = 7
@devec r = abc[3:v,1]
@test isequal(r, a[3:v])

@devec r = abc[3:v,j]
@test isequal(r, b[3:v])

u = 2
@devec r = abc[u:,1]
@test isequal(r, a[u:])

@devec r = abc[u:6,1]
@test isequal(r, a[u:6])

@devec r = abc[u:,j]
@test isequal(r, b[u:])

@devec r = abc[u:6,j]
@test isequal(r, b[u:6])

v = 7
@devec r = abc[u:v,1]
@test isequal(r, a[u:v])

@devec r = abc[u:v,j]
@test isequal(r, b[u:v])


# col-ref on LHS

r = zeros(size(abc))
@devec r[:,1] = b[:]
rr = zeros(size(abc))
rr[:,1] = b[:]
@test isequal(r, rr)

r = zeros(size(abc))
@devec r[3:6,1] = cv
rr = zeros(size(abc))
rr[3:6,1] = cv
@test isequal(r, rr)

r = zeros(size(abc))
@devec r[3:6,1] = b[2:5]
rr = zeros(size(abc))
rr[3:6,1] = b[2:5]
@test isequal(r, rr)

u = 1

r = zeros(size(abc))
@devec r[1:,1] = b[u:]
rr = zeros(size(abc))
rr[1:,1] = b[u:]
@test isequal(r, rr)

r = zeros(size(abc))
@devec r[u:,1] = b[:]
rr = zeros(size(abc))
rr[u:,1] = b[:]
@test isequal(r, rr)

j = 3
u = 2

r = zeros(size(abc))
@devec r[2:,j] = b[u:]
rr = zeros(size(abc))
rr[2:,j] = b[u:]
@test isequal(r, rr)

r = zeros(size(abc))
@devec r[u:,j] = b[2:]
rr = zeros(size(abc))
rr[u:,j] = b[2:]
@test isequal(r, rr)

u, v = 4, 7

r = zeros(size(abc))
@devec r[3:6,j] = b[u:v]
rr = zeros(size(abc))
rr[3:6,j] = b[u:v]
@test isequal(r, rr)

r = zeros(size(abc))
@devec r[u:v,j] = b[2:5]
rr = zeros(size(abc))
rr[u:v,j] = b[2:5]
@test isequal(r, rr)


###########################################################
#
#	row references
#
###########################################################

# row-ref on RHS

i = 2

@devec r = abct[1,:]
@test isequal(r, at)

@devec r = abct[1,1:]
@test isequal(r, abct[1,1:])

@devec r = abct[1,1:5]
@test isequal(r, abct[1,1:5])

@devec r = abct[i,:]
@test isequal(r, abct[i,:])

@devec r = abct[i,1:]
@test isequal(r, abct[i,1:])

@devec r = abct[i,1:5]
@test isequal(r, abct[i,1:5])

v = 4
@devec r = abct[1,1:v]
@test isequal(r, abct[1,1:v])

@devec r = abct[1,3:]
@test isequal(r, abct[1,3:])

@devec r = abct[1,3:6]
@test isequal(r, abct[1,3:6])

@devec r = abct[i,1:v]
@test isequal(r, abct[i,1:v])

@devec r = abct[i,3:]
@test isequal(r, abct[i,3:])

@devec r = abct[i,3:6]
@test isequal(r, abct[i,3:6])

v = 7
@devec r = abct[1,3:v]
@test isequal(r, abct[1,3:v])

@devec r = abct[i,3:v]
@test isequal(r, abct[i,3:v])

u = 2
@devec r = abct[1,u:]
@test isequal(r, abct[1,u:])

@devec r = abct[1,u:6]
@test isequal(r, abct[1,u:6])

@devec r = abct[i,u:]
@test isequal(r, abct[i,u:])

@devec r = abct[i,u:6]
@test isequal(r, abct[i,u:6])

v = 7
@devec r = abct[1,u:v]
@test isequal(r, abct[1,u:v])

@devec r = abct[i,u:v]
@test isequal(r, abct[i,u:v])

# row-ref on LHS

r = zeros(size(abct))
@devec r[1,:] = bt[:]
rr = zeros(size(abct))
rr[1,:] = bt[:]
@test isequal(r, rr)

r = zeros(size(abct))
@devec r[1,3:6] = cv
rr = zeros(size(abct))
rr[1,3:6] = cv
@test isequal(r, rr)

r = zeros(size(abct))
@devec r[1,3:6] = bt[2:5]
rr = zeros(size(abct))
rr[1,3:6] = bt[2:5]
@test isequal(r, rr)

u = 1

r = zeros(size(abct))
@devec r[1,1:] = bt[u:]
rr = zeros(size(abct))
rr[1,1:] = bt[u:]
@test isequal(r, rr)

r = zeros(size(abct))
@devec r[1,u:] = bt[:]
rr = zeros(size(abct))
rr[1,u:] = bt[:]
@test isequal(r, rr)

i = 2
u = 2

r = zeros(size(abct))
@devec r[i,2:] = bt[u:]
rr = zeros(size(abct))
rr[i,2:] = bt[u:]
@test isequal(r, rr)

r = zeros(size(abct))
@devec r[i,u:] = bt[2:]
rr = zeros(size(abct))
rr[i,u:] = bt[2:]
@test isequal(r, rr)

u, v = 4, 7

r = zeros(size(abct))
@devec r[i,3:6] = bt[u:v]
rr = zeros(size(abct))
rr[i,3:6] = bt[u:v]
@test isequal(r, rr)

r = zeros(size(abct))
@devec r[i,u:v] = bt[2:5]
rr = zeros(size(abct))
rr[i,u:v] = bt[2:5]
@test isequal(r, rr)




