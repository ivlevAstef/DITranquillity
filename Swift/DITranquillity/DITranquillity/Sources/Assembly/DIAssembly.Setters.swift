//
//  DIAssembly.Setters.swift
//  DITranquillity
//
//  Created by Alexander Ivlev on 11/07/16.
//  Copyright © 2016 Alexander Ivlev. All rights reserved.
//

public extension DIAssembly {
  public final func addModules(modules: DIModule...) {
    for module in modules {
      addModule(module)
    }
  }

  public final func addDependencies<T0: DIAssembly>(t0: T0.Type) {
    addDependency(t0)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly>(t0: T0.Type, _ t1: T1.Type) {
    addDependencies(t0)
    addDependency(t1)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type) {
    addDependencies(t0, t1)
    addDependency(t2)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type) {
    addDependencies(t0, t1, t2)
    addDependency(t3)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type) {
    addDependencies(t0, t1, t2, t3)
    addDependency(t4)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type) {
    addDependencies(t0, t1, t2, t3, t4)
    addDependency(t5)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5)
    addDependency(t6)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6)
    addDependency(t7)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7)
    addDependency(t8)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8)
    addDependency(t9)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9)
    addDependency(t10)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10)
    addDependency(t11)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly, T12: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type, _ t12: T12.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11)
    addDependency(t12)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly, T12: DIAssembly, T13: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type, _ t12: T12.Type, _ t13: T13.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12)
    addDependency(t13)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly, T12: DIAssembly, T13: DIAssembly, T14: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type, _ t12: T12.Type, _ t13: T13.Type, _ t14: T14.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13)
    addDependency(t14)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly, T12: DIAssembly, T13: DIAssembly, T14: DIAssembly, T15: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type, _ t12: T12.Type, _ t13: T13.Type, _ t14: T14.Type, _ t15: T15.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14)
    addDependency(t15)
  }
  
  public final func addDependencies<T0: DIAssembly, T1: DIAssembly, T2: DIAssembly, T3: DIAssembly, T4: DIAssembly, T5: DIAssembly, T6: DIAssembly, T7: DIAssembly, T8: DIAssembly, T9: DIAssembly, T10: DIAssembly, T11: DIAssembly, T12: DIAssembly, T13: DIAssembly, T14: DIAssembly, T15: DIAssembly, T16: DIAssembly>(t0: T0.Type, _ t1: T1.Type, _ t2: T2.Type, _ t3: T3.Type, _ t4: T4.Type, _ t5: T5.Type, _ t6: T6.Type, _ t7: T7.Type, _ t8: T8.Type, _ t9: T9.Type, _ t10: T10.Type, _ t11: T11.Type, _ t12: T12.Type, _ t13: T13.Type, _ t14: T14.Type, _ t15: T15.Type, _ t16: T16.Type) {
    addDependencies(t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15)
    addDependency(t16)
  }
  
}
