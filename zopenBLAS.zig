const std = @import("std");

pub const zlinalg = @import("zlinalg");
pub const Mat = zlinalg.Mat; // gen matrix struct
pub const Vec = zlinalg.Vec; // vector struct

// utilities
const util = @import("src/util.zig");

pub const ValueType = util.ValueType;
pub const ElementType = util.ElementType;
pub const isComplex = util.isComplex;

//  header info from cblas.h
pub const cblas = @cImport(@cInclude("/opt/OpenBLAS/include/cblas.h"));
pub const blas_int = cblas.blasint;
pub const blas_uint = c_uint;
pub const blas_cmpx_flt = cblas.openblas_complex_float;
pub const blas_cmpx_dbl = cblas.openblas_complex_double;

pub const BLAS_layout = enum(blas_uint) {
    row_maj = cblas.CblasRowMajor,
    col_maj = cblas.CblasColMajor,
    _,
};

pub const BLAS_trans = enum(blas_uint) {
    t = cblas.CblasTrans,
    no_t = cblas.CblasNoTrans,
    h = cblas.CblasConjTrans,
    no_h = cblas.CblasConjNoTrans,
    _,
};

pub const BLAS_triang = enum(blas_uint) {
    upper = cblas.CblasUpper,
    lower = cblas.CblasLower,
    _,
};

pub const BLAS_diag = enum(blas_uint) {
    non_unit = cblas.CblasNonUnit,
    unit = cblas.CblasUnit,
    _,
};

pub const BLAS_side = enum(blas_uint) {
    left = cblas.CblasLeft,
    right = cblas.CblasRight,
    _,
};

//  header info from lapacke.h
pub const lapack = @cImport(@cInclude("/opt/OpenBLAS/include/lapacke.h"));
pub const lp_int = lapack.lapack_int;
pub const lp_uint = c_uint;
pub const lp_cmpx_flt = lapack.lapack_complex_float;
pub const lp_cmpx_dbl = lapack.lapack_complex_double;

pub const LP_trans = enum(u8) {
    t = 'T',
    no_t = 'N',
    h = 'C',
    _,
};

pub const LP_layout = enum(lp_int) {
    row_maj = lapack.LAPACK_ROW_MAJOR,
    col_maj = lapack.LAPACK_COL_MAJOR,
    _,
};

// Level 1 BLAS -----------------------------------------------
const level_1 = @import("src/BLAS/level_1.zig");

pub const asum = level_1.asum; // sum of abs values
pub const axpy = level_1.axpy; // y = a*x +y
pub const copy = level_1.copy; // copy
pub const dot = level_1.dot; // real dot product (x^t * y)
pub const dotu = level_1.dotu; // complex dot prod (x^t * y)
pub const dotc = level_1.dotc; // complex dot prod (x^h * y)
pub const dsdot = level_1.dsdot; // dot product of single prec with dbl output
pub const iamax = level_1.iamax; // index of max abs value
pub const iamin = level_1.iamin; // index of min abs value
pub const imax = level_1.imax; // index of max value
pub const imin = level_1.imin; // index of min value
pub const nrm2 = level_1.nrm2; // euclidean norm
pub const rot = level_1.rot; // setup Givens rotation
pub const rotg = level_1.rotg; // setup Givens rotation
pub const rotm = level_1.rotm; // apply modified Givens rot
pub const rotmg = level_1.rotmg; // construct modilfied Givens rotation matrix
pub const sdsdot = level_1.sdsdot; // single prec dot product alpha*(x^t * y)
pub const swap = level_1.swap; // swap x and y
pub const scal = level_1.scal; // scale vector by element type
pub const scal_cr = level_1.scal_cr; // scale complex vector by real

// pub const xdot  = @import("BLAS/level_1.zig").xdot; // euclidean norm

// Level 2 BLAS -----------------------------------------------
const level_2 = @import("src/BLAS/level_2.zig");

// general matrix
pub const gemv = level_2.gemv; // matrix vector multiply
pub const ger = level_2.ger; // matrix vector multiply
pub const gerc = level_2.gerc; // matrix vector multiply
pub const geru = level_2.geru; // matrix vector multiply

// general band
// pub const gbmv  = level_2.gbmv; // banded matrix vector mult

// hermitian, hermitian band, hermitian packed
// pub const hemv  = level_2.hemv; // herm matrix vect mult
// pub const hbmv  = level_2.hbmv; // herm banded mat vect mult
// pub const hpmv  = level_2.hpmv; // herm packed mat vect mult

// symmetric, symmetric band, symmetric packed
// pub const symv  = level_2.symv; // symmetric mat vect mult
// pub const sbmv  = level_2.sbmv; // sym banded mat vect mult
// pub const spmv  = level_2.spmv; // sym packed mat vect mult

// // triangular, triangular band, triangular packed
// pub const trmv  = level_2.trmv; // triangular mat vect mult
// pub const tbmv  = level_2.tbmv; // triang banded mat vect mult
// pub const tpmv  = level_2.tpmv; // triang packed mat vect mult

// pub const trsv  = level_2.trsv; // solving triang matrix problems
// pub const tbsv  = level_2.tbsv; // solving triang banded mat prob
// pub const tpsv  = level_2.tpsv; // solving triang packed mat prob

// rank 1 operations (A = alpha*x*y' + A)
// pub const ger   = level_2.ger;  // performs rank 1 operation
// pub const geru  = level_2.geru; // performs complex rank 1 op
// pub const gerc  = level_2.gerc; // performs cmplx rank 1 op (w/conj)

// hermitian rank 1 & 2 operations
// pub const her  = level_2.her;  // herm rank 1
// pub const hpr  = level_2.hpr;  // packed herm rank 1
// pub const her2 = level_2.her2; // herm rank 2
// pub const hpr2 = level_2.hpt2; // packed herm rank 2

// symmetric rank 1 operation
// pub const syr  = level_2.syr;  // symmetric rank 1 operation
// pub const spr  = level_2.spr;  // packed sym rank 1 op
// pub const syr2 = level_2.syr2; // symmetric rank 2 operation
// pub const spr2 = level_2.spr2; // packed sym rank 2 op

// Level 3 BLAS -----------------------------------------------
const level_3 = @import("src/BLAS/level_3.zig");

// matrix matrix multiply
pub const gemm = level_3.gemm; // matrix matrix multiply
// pub const symm  = level_3.symm; // symmetrix matrix matrix mult
// pub const hemm  = level_3.hemm; // hermitian matrix matrix mult

// rank k and 2k matrix updates
// pub const syrk  = level_3.syrk;   // symmetric rank k update to matrix
// pub const herk  = level_3.herk;   // hermitian rank k update to matrix
// pub const syr2k  = level_3.syr2k; // symmetrik rank 2k update to matrix
// pub const her2k  = level_3.her2k; // hermetian rank 2k update to matrix

// triangular matrix  multiply and solving
// pub const trmm  = level_3.trmm; // triangular matrix matrix multiply
// pub const trsm  = level_3.trsm; // trianular matrix solving

// Lapack ----------------------------------------------------------

// linear equation solvers
// const XXXX  = linear_eq.XXXX;    // XXXX

// least square solvers
const least_sqr = @import("src/LAPACK/least_sqr.zig");
pub const gels = least_sqr.gels; // general least squares

