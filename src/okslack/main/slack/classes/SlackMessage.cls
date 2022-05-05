/**
 * Slack Message 
 * https://api.slack.com/messaging/composing
 */
public class SlackMessage {
    public String text;
    public List<SlackBlock> blocks = new List<SlackBlock>();
    
    public SlackMessage setText(String text) {
        this.text = text;
        return this;
    }
    
    public SlackMessage addBlock(SlackBlock block) {
        blocks.add(block);
        return this;
    }
    
    public SlackBlockHeader createBlockHeader() {
        SlackBlockHeader block = new SlackBlockHeader();
        addBlock(block);
        return block;
    }

    public SlackBlockSection createBlockSection() {
        SlackBlockSection block = new SlackBlockSection();
        addBlock(block);
        return block;
    }
    
    public String toJSON() {
        return JSON.serialize(this);
    }
}