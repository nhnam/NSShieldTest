//
//  NSDICT.h
//  Ring
//
//  Created by Nguyen Hoang Nam on 25/5/16.
//  Copyright © 2016 Medpats Global Pte. Ltd. All rights reserved.
//

#ifndef NSDICT_h
#define NSDICT_h

#define NSDICT(firstKey, ...) NSDictionaryWithKeysAndValues(firstKey, __VA_ARGS__)
static __attribute__ ((sentinel)) NSDictionary * NSDictionaryWithKeysAndValues(id firstKey, ...) {
   va_list kvl;
   va_start(kvl, firstKey);
   
   size_t dyn_capacity;
   size_t dyn_count;
   __unsafe_unretained id * dyn_keys;
   __unsafe_unretained id * dyn_values;
   id key, value;
   
   
   // Do up to 16 using static allocation
   {
      NSUInteger static_capacity = 16;
      __unsafe_unretained id keys[static_capacity];
      __unsafe_unretained id values[static_capacity];
      NSUInteger count = 0;
      
      key = firstKey;
      value = va_arg(kvl, id);
      
      do {
         if (value) {
            keys[count] = key;
            values[count] = value;
            count++;
         }
         
         key = va_arg(kvl, id);
         if (!key) {
            va_end(kvl);
            return [NSDictionary dictionaryWithObjects:values forKeys:keys count:count];
         }
         value = va_arg(kvl, id);
         
         
         if (count == static_capacity) {
            dyn_capacity = static_capacity * 2;
            dyn_count  = static_capacity;
            dyn_keys   = (__unsafe_unretained id *)malloc(dyn_capacity * sizeof(id));
            dyn_values = (__unsafe_unretained id *)malloc(dyn_capacity * sizeof(id));
            
            memcpy(dyn_keys, keys, static_capacity * sizeof(id));
            memcpy(dyn_values, values, static_capacity * sizeof(id));
            break;
         }
         
      } while (1);
   }
   
   
   // For > 16 entries
   do {
      if (value) {
         dyn_keys[dyn_count] = key;
         dyn_values[dyn_count] = value;
         dyn_count++;
         if (dyn_count == dyn_capacity) {
            dyn_capacity += 16;
            dyn_keys = (__unsafe_unretained id *)realloc(dyn_keys, dyn_capacity * sizeof(id));
            dyn_values = (__unsafe_unretained id *)realloc(dyn_values, dyn_capacity * sizeof(id));
         }
      }
      
      key = va_arg(kvl, id);
      if (!key) break;
      value = va_arg(kvl, id);
   } while (1);
   
   va_end(kvl);
   
   NSDictionary * dict = [NSDictionary dictionaryWithObjects:dyn_values forKeys:dyn_keys count:dyn_count];
   free(dyn_keys);
   free(dyn_values);
   return dict;
}
#endif /* NSDICT_h */
