
class heapIndexMin(object):
    def __init__(self, limit):
        self.maxN = limit
        self.N=0;
        
        self.qp = [-1 for i in range(self.maxN + 1)]        
        self.pq=[0 for i in range(self.maxN + 1)]
        self.keys=[0 for i in range(self.maxN + 1)]

    def NValue(self):
        return self.N
    
    def IsEmpty(self):
        return self.N==0
        
    def insert(self, idVal, keyVal):
        self.N=self.N + 1
        self.qp[idVal] = self.N
        self.keys[idVal] = keyVal
        self.pq[self.N]=idVal
        self.swim(self.N)
        
    def Contains(self, index):
        return self.qp[index]!= -1
        
    def swim(self, num):
        while(num>1): 
            if(self.less(num, int(num/2))):
                self.exch(int(num/2), num)
                num=int(num/2);
            else: return
            
            
    def sink(self, num):
        while(num*2 < self.N):
            if (self.less(num*2 , num*2+1)):
                chld=num*2+1
            else:
                chld=num*2
                
            if(self.less(chld, num)):
                self.exch(chld, num)
                num=chld
            else:
                break
                
    def less(self, index1, index2):
        return self.keys[self.pq[index1]] < self.keys[self.pq[index2]];
          
    def exch(self, index1, index2):
        swap = self.pq[index2]
        self.pq[index2]=self.pq[index1]
        self.pq[index1]=swap
        self.qp[self.pq[index2]]=index2
        self.qp[self.pq[index1]]=index1

    def change (self, idVal, KeyVal):
        self.keys[idVal]=KeyVal;
        self.swim(self.qp[idVal])
        #self.sink(self.qp[idVal])
    
    def AddCity(self, indexVal, KeyVal):
        if(self.Contains(indexVal)):
            if (self.keys[indexVal]>KeyVal) :           
                self.change(indexVal, KeyVal)
        else:
            self.insert(indexVal, KeyVal)
    
    def MinDistance(self):
        minIndex  = self.pq[1]        
        self.exch(1, self.N)
        self.keys[minIndex]=0
        self.qp[minIndex]=-1
        self.N=self.N-1
        self.sink(1)
        return minIndex
    
    def PrintCity(self):
        while(self.IsEmpty()==False):
            print self.MinDistance()