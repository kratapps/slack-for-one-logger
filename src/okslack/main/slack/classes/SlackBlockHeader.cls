public class SlackBlockHeader implements SlackBlock {
    public final String type = 'header';
    public SlackText text;

    public SlackText createText() {
        text = new SlackText();
        return text;
    }

    public SlackBlockHeader setMrkdwn(String value) {
        text = createText().setMrkdwn().setText(value);
        return this;
    }

    public SlackBlockHeader setPlainText(String value) {
        text = createText().setPlainText().setText(value);
        return this;
    }
}