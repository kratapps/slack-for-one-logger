public class SlackText {
    public Type type;
    public String text;
    
    public SlackText setPlainText() {
        type = SlackText.Type.plain_text;
        return this;
    }

    public SlackText setMrkdwn() {
        type = SlackText.Type.mrkdwn;
        return this;
    }
    
    public SlackText setText(String text) {
        this.text = text;
        return this;
    }
    
    public enum Type {
        plain_text,
        mrkdwn
    }
}