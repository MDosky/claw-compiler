! Test the CLAW abstraction model with two additional dimensions.

MODULE mo_column
  IMPLICIT NONE
CONTAINS
  ! Compute only one column
  SUBROUTINE compute_column(nz, q, t)
    IMPLICIT NONE

    INTEGER, INTENT(IN)   :: nz   ! Size of the array field
    REAL, INTENT(INOUT)   :: t(:) ! Field declared as one column only
    REAL, INTENT(INOUT)   :: q(:) ! Field declared as one column only
    INTEGER :: k                  ! Loop index
    REAL :: c                     ! Coefficient

    ! CLAW definition

    ! Define two dimensions that will be added to the variables defined in the
    ! data clause.
    ! Apply the parallelization transformation on this subroutine.

    !$claw define dimension i(1,nx) &
    !$claw define dimension j(1,ny) &
    !$claw parallelize data(q,t) over (i,j,:)

    c = 5.345
    DO k = 2, nz
      t(k) = c * k
      q(k) = q(k - 1)  + t(k) * c
    END DO
    q(nz) = q(nz) * c
  END SUBROUTINE compute_column
END MODULE mo_column


PROGRAM test_abstraction2
  USE mo_column, ONLY: compute_column

  REAL, DIMENSION(10,10,60) :: q, t ! fields as declared in the whole model
  INTEGER :: nx, ny, nz             ! Size of array fields
  INTEGER :: i,j                    ! Loop indices

  nx = 10
  ny = 10
  nz = 60

  DO i = 1, nx
    DO j = 1, ny
      q(i,j,1) = 0.0
      t(i,j,1) = 0.0
    END DO
  END DO

#ifdef _CLAW
  CALL compute_column(nz, q, t, nx, ny)
#else
  DO i = 1, nx
    DO j = 1, ny
      CALL compute_column(nz, q(i,j,:), t(i,j,:))
    END DO
  END DO
#endif

  PRINT*,SUM(q)
  PRINT*,SUM(t)
END PROGRAM test_abstraction2