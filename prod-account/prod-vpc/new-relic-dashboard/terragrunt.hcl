terraform {
    source = "git@github.com:devopsidiot/interview-infra-tf.git//new-relic-dashboard"
}
dependency "eks" {
  config_path = "../eks"
}
inputs = {
  ## Dashboard Widget Values: ##
  newrelic_dashboard_name        = "prod-eks"
  newrelic_dashboard_permissions = "public_read_only"
  newrelic_dashboard_pages = {
    "Infrastructure - Node Data" = {
      line_widgets = {
        "Node CPU Usage Percentage" = {
          widget_line_nrql   = "SELECT latest(k8s.node.allocatableCpuCoresUtilization) FROM Metric TIMESERIES FACET `k8s.nodeName` LIMIT 10 SINCE 1800 seconds ago"
          widget_line_column = 1
          widget_line_row    = 1
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Node Memory Usage Percentage" = {
          widget_line_nrql   = "SELECT latest(allocatableMemoryUtilization) FROM K8sNodeSample TIMESERIES FACET `nodeName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_line_column = 5
          widget_line_row    = 1
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Node Storage Usage Percentage" = {
          widget_line_nrql   = "SELECT latest(fsCapacityUtilization) FROM K8sNodeSample TIMESERIES FACET `nodeName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_line_column = 9
          widget_line_row    = 4
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Node MemoryPressure" = {
          widget_line_nrql   = "SELECT latest(`condition.MemoryPressure`) FROM K8sNodeSample FACET nodeName SINCE 30 MINUTES AGO TIMESERIES"
          widget_line_column = 5
          widget_line_row    = 4
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Node PIDPressure" = {
          widget_line_nrql   = "SELECT latest(`condition.PIDPressure`) FROM K8sNodeSample FACET nodeName SINCE 30 MINUTES AGO TIMESERIES"
          widget_line_column = 1
          widget_line_row    = 7
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Node DiskPressure" = {
          widget_line_nrql   = "SELECT latest(`condition.DiskPressure`) FROM K8sNodeSample FACET nodeName SINCE 30 MINUTES AGO TIMESERIES"
          widget_line_column = 1
          widget_line_row    = 4
          widget_line_height = 3
          widget_line_width  = 4
        }
      },
      bar_widgets = {
        "Node Ready" = {
          widget_bar_nrql   = "SELECT latest(`condition.Ready`) FROM K8sNodeSample FACET nodeName SINCE 30 MINUTES AGO TIMESERIES"
          widget_bar_column = 9
          widget_bar_row    = 1
          widget_bar_height = 3
          widget_bar_width  = 2
        }
      },
      pie_widgets = {
        "Unscheduable Nodes" = {
          widget_pie_nrql   = "SELECT latest(unschedulable) FROM K8sNodeSample FACET nodeName SINCE 30 MINUTES AGO TIMESERIES"
          widget_pie_column = 11
          widget_pie_row    = 1
          widget_pie_height = 3
          widget_pie_width  = 2
        }
      }
    },
    "Infrastructure - Pod Data" = {
      table_widgets = {
        "Pod Status" = {
          widget_table_nrql   = "SELECT uniques(status) FROM K8sPodSample FACET `podName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_table_column = 1
          widget_table_row    = 4
          widget_table_height = 5
          widget_table_width  = 12
        },
        "Pod Count" = {
          widget_table_nrql   = "SELECT latest(podsDesired), latest(podsTotal), latest(podsUnavailable), latest(podsMissing)  FROM K8sDeploymentSample FACET `deploymentName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_table_column = 1
          widget_table_row    = 1
          widget_table_height = 3
          widget_table_width  = 12
        }
      },
    },
    "Infrastructure - Container Data" = {
      line_widgets = {
        "Container Restart Count" = {
          widget_line_nrql   = "SELECT latest(restartCount) FROM K8sContainerSample TIMESERIES FACET `containerName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_line_column = 9
          widget_line_row    = 1
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Container CPU Usage" = {
          widget_line_nrql   = "SELECT latest(cpuCoresUtilization) FROM K8sContainerSample TIMESERIES FACET `containerName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_line_column = 1
          widget_line_row    = 1
          widget_line_height = 3
          widget_line_width  = 4
        },
        "Container Memory Usage" = {
          widget_line_nrql   = "SELECT latest(memoryWorkingSetUtilization) FROM K8sContainerSample TIMESERIES FACET `containerName` LIMIT 10 SINCE 1800 seconds ago EXTRAPOLATE"
          widget_line_column = 5
          widget_line_row    = 1
          widget_line_height = 3
          widget_line_width  = 4
        }
      },
        table_widgets = {
        "EKS Error Logs" = {
          widget_table_nrql   = "SELECT `message` FROM Log WHERE allColumnSearch('quiet-time-temp-dev-eks', insensitive: true) AND allColumnSearch('error', insensitive: true)"
          widget_table_column = 1
          widget_table_row    = 10  # Adjust position as per your layout
          widget_table_height = 3
          widget_table_width  = 12
        }
      }
    }
  }
}
include {
  path = find_in_parent_folders()
}