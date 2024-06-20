https://blog.lujun.co/2019/06/26/mesh_rendering/
其中解释了一些基础的Unity网格内容
同时通过一份基础shader解释了Unity中uv语义填充的问题

```
所以当设置某组 uv 时，若其后面的 uv(x) 没有设置，那么后边的将会被设置一份和 uv 一样的纹理坐标值，直至遇到某个 uv(x) 又被设置了值为止，后面没有设置纹理坐标的又会拥有刚刚设置的这份新的值。都不设置为默认值 0
```





https://blog.lujun.co/2019/06/29/texture_in_unity_rendering/

其中比较详细的展示了纹理Wrap Mode和Filter Mode的变换过程
