/**
 * Slack Block Section
 * https://api.slack.com/messaging/composing/layouts
 */
public class SlackBlockSection implements SlackBlock {
    public final String type = 'section';
    public SlackText text;
    
    public SlackText createText() {
        text = new SlackText();
        return text;
    }

    public SlackBlockSection setMrkdwn(String value) {
        text = createText().setMrkdwn().setText(value);
        return this;
    }

    public SlackBlockSection setPlainText(String value) {
        text = createText().setPlainText().setText(value);
        return this;
    }
}