using UnityEngine;

namespace DefaultNamespace
{
    public class Test : MonoBehaviour
    {
        [SerializeField]
        private MeshFilter _meshFilter;

        private void Start()
        {
            foreach (var vertex in _meshFilter.mesh.vertices)
            {
                Debug.Log($"vertex is {vertex}");
            }
        }
    }
}