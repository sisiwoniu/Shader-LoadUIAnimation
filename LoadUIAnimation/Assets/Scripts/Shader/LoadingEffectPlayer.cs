using System;
using System.Collections;
using UnityEngine.UI;
using UnityEngine;

public class LoadingEffectPlayer : MonoBehaviour {

    [SerializeField]
    private bool UIType = false;

    [SerializeField]
    private AnimationCurve Curve;

    [SerializeField, Range(0.1f, 10f)]
    private float Duration = 1f;

    private MaterialPropertyBlock block;

    private Renderer s_renderer;

    private int valueID;

    private Material uiMaterial;

    private MaskableGraphic uiElement;

    public void ShowLoad(Action CallBack) {
        StartCoroutine(LoadAnimation(true, CallBack));
    }

    public void CloseLoad(Action CallBack) {
        StartCoroutine(LoadAnimation(false, CallBack));
    }

    private void Start() {
        valueID = Shader.PropertyToID("_Value");

        if(UIType) {
            uiElement = GetComponent<MaskableGraphic>();

            uiMaterial = Instantiate(uiElement.material);

            uiElement.material = uiMaterial;
        } else {
            block = new MaterialPropertyBlock();

            s_renderer = GetComponent<Renderer>();

            s_renderer.GetPropertyBlock(block);
        }
    }

    private void Update() {
        if(Input.GetKeyDown(KeyCode.A)) {
            ShowLoad(() => {
                Debug.Log("show completed");
            });
        }

        if(Input.GetKeyDown(KeyCode.D)) {
            CloseLoad(() => {
                Debug.Log("close Completed");
            });
        }
    }

    IEnumerator LoadAnimation(bool Show, Action Callback) {
        var time = 0f;

        var startValue = Show ? -0.1f : 1f;

        var targetValue = Show ? 1f : -0.1f;

        while(time <= Duration) {
            time += Time.deltaTime;

            var v = Mathf.Lerp(startValue, targetValue, Curve.Evaluate(Mathf.Clamp01(time / Duration)));

            if(UIType) {
                uiMaterial.SetFloat(valueID, v);
            } else {
                block.SetFloat(valueID, v);

                s_renderer.SetPropertyBlock(block);
            }

            yield return null;
        }

        Callback?.Invoke();
    }
}
