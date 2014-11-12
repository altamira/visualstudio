using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ViewModel.Extensions
{
    public class CustomComparer<T> : IEqualityComparer<T>
    {
        public bool Equals(T x, T y)
        {
            return x.Equals(y);
        }

        public int GetHashCode(T obj)
        {
            return obj.GetHashCode();
        }
    }
}
