# gh-action-setup-keptn

## Example usage

```yaml
name: Setup Keptn
on:
  - push
  - workflow_dispatch

jobs:
  send_keptn_event:
    runs-on: ubuntu-latest
    name: Setup Keptn
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Setup Keptn
        id: setup-keptn
        uses: keptn/gh-action-setup-keptn@main
        with:
          KeptnVersion: '0.8.1'
          GKEClusterVersion: '1.18'
          GKEProjectName: ${{ secrets.GKE_PROJECT_NAME }}
          GCloudServiceKey: ${{ secrets.GCLOUD_SERVICE_KEY }}
          GKEClusterName: 'keptn-meta-test'

      - name: Trigger delivery
        id: trigger-delivery
        uses: keptn/gh-action-send-event@main
        with:
          keptnApiUrl: ${{ steps.setup-keptn.outputs.keptnAPIURL }}/v1/event
          keptnApiToken: ${{ steps.setup-keptn.outputs.keptnAPIToken }}
          event: |
            {
              "data": {
                "configurationChange": {
                  "values": {
                    "control-plane": {
                      "enabled": true
                    }
                  }
                },
                "deployment": {
                  "deploymentURIsLocal": null,
                  "deploymentstrategy": "direct"
                },
                "message": "",
                "project": "keptn",
                "result": "",
                "service": "keptn",
                "stage": "dev",
                "status": ""
              },
              "source": "gh",
              "specversion": "1.0",
              "type": "sh.keptn.event.dev.delivery.triggered",
              "shkeptnspecversion": "0.2.1"
            }
```