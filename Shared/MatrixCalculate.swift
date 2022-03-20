//
//  RungeKutta4th.swift
//  RungeKuttaShrodingerEq
//
//  Created by daksh patel on 3/12/21.
//

import Foundation
import SwiftUI
import Accelerate


class matrixCalculate: NSObject, ObservableObject {
    
    var energies: [Double] = []
    var psi: [[Double]] = []
    var wellLength = 10.0
    let Nvalues = 30.0
    
    func performMatrixOperations() {
        
        /* Calculate Eigenvalues */
        
        /* Real Eigenvalues */
        
        //let a = [[[Int]]](repeating:[[Int]](repeating:[Int](repeating:1,count:3), count:3), count:3)
        let hbarOverM = 7.61996423107385308868
        let stepSize = wellLength/(Nvalues)
        let H = -1.0*hbarOverM/(2*pow(stepSize,2))
        
        var realStartingArray: [[Double]] = []
        
        for i in  0...Int(Nvalues)-1{
            var array = Array(repeating: 0.0, count: Int(Nvalues))
           
            if (i == 0){
                array[i] = -2.0*H
                array[i+1] = 1.0*H
            }
            
            else if (i == Int(Nvalues)-1){
                array[i] = -2.0*H
                array[i-1] = 1.0*H
            }
            
            else {
                array[i-1] =  1.0*H
                array[i]   = -2.0*H
                array[i+1] =  1.0*H
            }
            
            realStartingArray.append(array)
            
        }
        
        
        let N = Int32(realStartingArray.count)
        
        let flatArray :[Double] = pack2dArray(arr: realStartingArray, rows: Int(N), cols: Int(N))
        
        calculateEigenvalues(arrayForDiagonalization: flatArray)
        
    }

    
    /// calculateEigenvalues
    ///
    /// - Parameter arrayForDiagonalization: linear Column Major FORTRAN Array for Diagonalization
    /// - Returns: String consisting of the Eigenvalues and Eigenvectors
    func calculateEigenvalues(arrayForDiagonalization: [Double]) {
        /* Integers sent to the FORTRAN routines must be type Int32 instead of Int */
        //var N = Int32(sqrt(Double(startingArray.count)))
        
        
        var N  = Int32(sqrt(Double(arrayForDiagonalization.count)))
        var N2 = Int32(sqrt(Double(arrayForDiagonalization.count)))
        var N3 = Int32(sqrt(Double(arrayForDiagonalization.count)))
        var N4 = Int32(sqrt(Double(arrayForDiagonalization.count)))

        var flatArray = arrayForDiagonalization
        
        var error : Int32 = 0
        var lwork = Int32(-1)
        // Real parts of eigenvalues
        var wr = [Double](repeating: 0.0, count: Int(N))
        // Imaginary parts of eigenvalues
        var wi = [Double](repeating: 0.0, count: Int(N))
        // Left eigenvectors
        var vl = [Double](repeating: 0.0, count: Int(N*N))
        // Right eigenvectors
        var vr = [Double](repeating: 0.0, count: Int(N*N))
        
        
        /* Eigenvalue Calculation Uses dgeev */
        /*   int dgeev_(char *jobvl, char *jobvr, Int32 *n, Double * a, Int32 *lda, Double *wr, Double *wi, Double *vl,
         Int32 *ldvl, Double *vr, Int32 *ldvr, Double *work, Int32 *lwork, Int32 *info);*/
        
        /* dgeev_(&calculateLeftEigenvectors, &calculateRightEigenvectors, &c1, AT, &c1, WR, WI, VL, &dummySize, VR, &c2, LWork, &lworkSize, &ok)    */
        /* parameters in the order as they appear in the function call: */
        /* order of matrix A, number of right hand sides (b), matrix A, */
        /* leading dimension of A, array records pivoting, */
        /* result vector b on entry, x on exit, leading dimension of b */
        /* return value =0 for success*/
        
        
        /* Calculate size of workspace needed for the calculation */
        
        var workspaceQuery: Double = 0.0
        dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspaceQuery, &lwork, &error)
        
        print("Workspace Query \(workspaceQuery)")
        
        /* size workspace per the results of the query */
        
        var workspace = [Double](repeating: 0.0, count: Int(workspaceQuery))
        lwork = Int32(workspaceQuery)
        
        /* Calculate the size of the workspace */
        
        dgeev_(UnsafeMutablePointer(mutating: ("N" as NSString).utf8String), UnsafeMutablePointer(mutating: ("V" as NSString).utf8String), &N, &flatArray, &N2, &wr, &wi, &vl, &N3, &vr, &N4, &workspace, &lwork, &error)
        
        
        energies = wr
        psi = unpack2dArray(arr: vr, rows: Int(N), cols: Int(N))
    
    }
    
    
    /// pack2DArray
    /// Converts a 2D array into a linear array in FORTRAN Column Major Format
    ///
    /// - Parameters:
    ///   - arr: 2D array
    ///   - rows: Number of Rows
    ///   - cols: Number of Columns
    /// - Returns: Column Major Linear Array
    func pack2dArray(arr: [[Double]], rows: Int, cols: Int) -> [Double] {
        var resultArray = Array(repeating: 0.0, count: rows*cols)
        for Iy in 0...cols-1 {
            for Ix in 0...rows-1 {
                let index = Iy * rows + Ix
                resultArray[index] = arr[Ix][Iy]
            }
        }
        return resultArray
    }
    
    /// unpack2DArray
    /// Converts a linear array in FORTRAN Column Major Format to a 2D array in Row Major Format
    ///
    /// - Parameters:
    ///   - arr: Column Major Linear Array
    ///   - rows: Number of Rows
    ///   - cols: Number of Columns
    /// - Returns: 2D array
    func unpack2dArray(arr: [Double], rows: Int, cols: Int) -> [[Double]] {
        var resultArray = [[Double]](repeating:[Double](repeating:0.0 ,count:rows), count:cols)
        for Iy in 0...cols-1 {
            for Ix in 0...rows-1 {
                let index = Iy * rows + Ix
                resultArray[Iy][Ix] = arr[index]
            }
        }
        return resultArray
    }
    
    
    
    
}
