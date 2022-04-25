public class SlackMentions {
    public List<SlackMention> mentions = new List<SlackMention>();

    public SlackMentions addMembers(List<String> memberIds) {
        for (String memberId : memberIds) {
            addMember(memberId);
        }
        return this;
    }
    
    public SlackMentions addMember(String memberId) {
        mentions.add(SlackMention.member(memberId));
        return this;
    }

    public SlackMentions addChannel(String channelId) {
        mentions.add(SlackMention.channel(channelId));
        return this;
    }

    public SlackMentions addHere() {
        mentions.add(SlackMention.here());
        return this;
    }

    public SlackMentions mentionHere(Boolean mentionHere) {
        if (mentionHere != null && mentionHere) {
            addHere();
        }
        return this;
    }

    public override String toString() {
        List<String> values = new List<String>();
        for (SlackMention mention : mentions) {
            values.add(mention.toString());
        }
        return String.join(values, ' ');
    }
}