/**
 * Slack Mention
 * https://api.slack.com/reference/surfaces/formatting#mentioning-users
 */
public class SlackMention {
    public SlackMention.Type type;
    public String id;
    
    public SlackMention setType(SlackMention.Type type) {
        this.type = type;
        return this;
    }
    
    public SlackMention setId(String id) {
        this.id = id;
        return this;
    }
    
    public static SlackMention member(String memberId) {
        return new SlackMention().setType(SlackMention.Type.MEMBER).setId(memberId);
    }

    public static SlackMention channel(String channelId) {
        return new SlackMention().setType(SlackMention.Type.CHANNEL).setId(channelId);
    }

    public static SlackMention here() {
        return new SlackMention().setType(SlackMention.Type.HERE);
    }

    public override String toString() {
        if (type == SlackMention.Type.HERE) {
            return '<!here>'; 
        } else if (type == SlackMention.Type.CHANNEL) {
            return '<#' + id + '>';
        } else if (type == SlackMention.Type.MEMBER) {
            return '<@' + id + '>';
        }
        return null;
    }
    
    public enum Type {
        MEMBER,
        CHANNEL,
        HERE
    }
}