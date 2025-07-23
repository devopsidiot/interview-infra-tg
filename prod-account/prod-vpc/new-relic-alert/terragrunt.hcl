terraform {
  source = "git@github.com:devopsidiot/interview-infra-tf.git//new-relic-alerts"
}


inputs = {
  newrelic_alert_policy                     = "flask-app-policy"
  newrelic_alert_policy_incident_preference = "PER_POLICY"

  newrelic_alert_email_channel_name     = "Ops Email Channel"
  newrelic_alert_slack_channel_name     = "Ops Slack Channel"
  newrelic_alert_pagerduty_channel_name = ""  # disable PagerDuty

  newrelic_alert_conditions = {
    latency = {
      violation_time_limit_seconds   = 3600
      expiration_duration            = 3600
      close_violations_on_expiration = true
      aggregation_method             = "AVERAGE"
      aggregation_delay              = 120
      aggregation_timer              = 120
      aggregation_window             = null

      nrql = [
        {
          query             = "SELECT average(duration) FROM Transaction WHERE appName = 'flask-app'"
          evaluation_offset = 30
        }
      ]

      warning = {}

      critical = {
        operator              = "above"
        threshold             = 0.5
        threshold_duration    = 60
        threshold_occurrences = "ALL"
      }
    }
  }
}

include {
   path = find_in_parent_folders()
}