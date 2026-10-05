locals {
  tags = merge(var.tags, {
    Project   = "aws-bedrock-usecases"
    UseCase   = "custom-guardrail-for-chatbot"
    ManagedBy = "terraform"
  })
}

# A composite guardrail for a customer-support chatbot: refuses to discuss
# competitors, redacts PII in input and output, blocks a custom word list on
# top of the managed profanity list, filters harmful content categories, and
# enforces that answers stay grounded in retrieved context.
resource "aws_bedrock_guardrail" "this" {
  name                      = var.guardrail_name
  description               = "Guardrail for the customer-support chatbot: blocks competitor discussion, redacts PII, filters harmful content, enforces grounding."
  blocked_input_messaging   = "Sorry, I can't help with that request."
  blocked_outputs_messaging = "Sorry, I'm not able to share that response."

  content_policy_config {
    filters_config {
      type            = "HATE"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }
    filters_config {
      type            = "VIOLENCE"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }
    filters_config {
      type            = "SEXUAL"
      input_strength  = "HIGH"
      output_strength = "HIGH"
    }
    filters_config {
      type            = "INSULTS"
      input_strength  = "MEDIUM"
      output_strength = "MEDIUM"
    }

    tier_config {
      tier_name = "STANDARD"
    }
  }

  sensitive_information_policy_config {
    dynamic "pii_entities_config" {
      for_each = var.pii_entity_types
      content {
        type           = pii_entities_config.value
        action         = "ANONYMIZE"
        input_action   = "BLOCK"
        input_enabled  = true
        output_action  = "ANONYMIZE"
        output_enabled = true
      }
    }
  }

  topic_policy_config {
    dynamic "topics_config" {
      for_each = var.denied_topics
      content {
        name       = topics_config.value.name
        definition = topics_config.value.definition
        examples   = topics_config.value.examples
        type       = "DENY"
      }
    }

    tier_config {
      tier_name = "STANDARD"
    }
  }

  word_policy_config {
    managed_word_lists_config {
      type = "PROFANITY"
    }

    dynamic "words_config" {
      for_each = var.blocked_words
      content {
        text = words_config.value
      }
    }
  }

  contextual_grounding_policy_config {
    filters_config {
      type      = "GROUNDING"
      threshold = 0.75
    }
    filters_config {
      type      = "RELEVANCE"
      threshold = 0.75
    }
  }

  tags = local.tags
}

# Publishes an immutable, invocable version of the guardrail. Applications
# reference guardrail_identifier + this numeric version (not the mutable
# draft) when calling InvokeModel/Converse with ApplyGuardrail.
resource "aws_bedrock_guardrail_version" "this" {
  guardrail_arn = aws_bedrock_guardrail.this.guardrail_arn
  description   = "Initial published version."
}
